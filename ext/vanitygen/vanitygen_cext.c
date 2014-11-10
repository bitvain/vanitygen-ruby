#include "ruby.h"
#include "pattern.h"

#define BITCOIN_ADDR_TYPE 0
#define BITCOIN_PRIV_TYPE 128

static VALUE difficulty_prefix(VALUE self, VALUE rb_pattern) {
    const char *pattern = RSTRING_PTR(rb_pattern);
    double difficulty = vg_prefix_get_difficulty(BITCOIN_ADDR_TYPE, pattern);
    return DBL2NUM(difficulty);
}

void Init_vanitygen_cext() {
    VALUE vanitygen = rb_define_module("Vanitygen");
    VALUE cext = rb_define_module_under(vanitygen, "Cext");
    rb_define_singleton_method(cext, "difficulty_prefix", difficulty_prefix, 1);
}
