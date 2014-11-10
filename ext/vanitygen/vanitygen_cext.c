#include "ruby.h"
#include "util.h"

static VALUE test(VALUE mod) {
    return rb_str_new2(vg_b58_alphabet);
}

void Init_vanitygen_cext() {
    VALUE vanitygen = rb_define_module("Vanitygen::Cext");
    rb_define_singleton_method(vanitygen, "test", test, 0);
}
