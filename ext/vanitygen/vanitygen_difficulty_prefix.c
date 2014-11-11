#include <ruby.h>

#include "pattern.h"

#include "magic_numbers.h"

VALUE vanitygen_difficulty_prefix(VALUE self, VALUE rb_pattern) {
    const char *pattern = RSTRING_PTR(rb_pattern);
    const double difficulty = vg_prefix_get_difficulty(BITCOIN_ADDR_TYPE, pattern);
    return DBL2NUM(difficulty);
}
