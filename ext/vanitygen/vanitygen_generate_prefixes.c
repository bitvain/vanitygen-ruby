#include <stdbool.h>
#include <ruby.h>

#include "pattern.h"
#include "util.h"

#include "rbsym.h"
#include "magic_numbers.h"

extern int start_threads(vg_context_t *vcp, int nthreads);

static void vg_output_timing_noop(vg_context_t *vcp, double count, unsigned long long rate, unsigned long long total) {}
static void vg_generate_output_error(vg_context_t *vcp, const char *info) {}

static VALUE rb_generate_return; // FIXME: thread unsafe
static void vg_generate_output_match(vg_context_t *vcp, EC_KEY *pkey, const char *pattern) {
    rb_generate_return = rb_hash_new();

    char buffer[VG_PROTKEY_MAX_B58];
    EC_POINT *ppnt = (EC_POINT *) EC_KEY_get0_public_key(pkey);

    vg_encode_address(ppnt, EC_KEY_get0_group(pkey), vcp->vc_pubkeytype, buffer);
    VALUE rb_address = rb_str_new2(buffer);
    rb_hash_aset(rb_generate_return, rbsym_address, rb_address);

    vg_encode_privkey(pkey, vcp->vc_privtype, buffer);
    VALUE rb_private_key = rb_str_new2(buffer);
    rb_hash_aset(rb_generate_return, rbsym_wif, rb_private_key);
}

VALUE vanitygen_generate_prefixes(VALUE self, VALUE rb_patterns, VALUE rb_caseinsensitive) {
    const bool caseinsensitive = RTEST(rb_caseinsensitive);

    vg_context_t *vcp = vg_prefix_context_new(BITCOIN_ADDR_TYPE, BITCOIN_PRIV_TYPE, caseinsensitive);
    vcp->vc_verbose = false;
    vcp->vc_result_file = NULL;        // Write pattern matches to <file>
    vcp->vc_remove_on_match = true;    // false = Keep pattern and continue search after finding a match
    vcp->vc_only_one = true;           // true = Stop after first match
    vcp->vc_format = VCF_PUBKEY;       // Generate address with the given format (pubkey or script)
    vcp->vc_pubkeytype = BITCOIN_ADDR_TYPE;
    vcp->vc_pubkey_base = NULL;        // Specify base public key for piecewise key generation

    vcp->vc_output_match = vg_generate_output_match;
    vcp->vc_output_error = vg_generate_output_error;
    vcp->vc_output_timing = vg_output_timing_noop;

    long len = RARRAY_LEN(rb_patterns);
    for(int i=0; i < len; i++) {
      VALUE rb_pattern = rb_ary_entry(rb_patterns, i);
      const char *pattern = RSTRING_PTR(rb_pattern);
      vg_context_add_patterns(vcp, &pattern, 1);
    }

    start_threads(vcp, 1); // FIXME: actual threading

    vcp->vc_free(vcp);

    return rb_generate_return;
}