#include <stdbool.h>
#include <ruby.h>

#include "rbsym.h"

VALUE vanitygen_ext_difficulty_prefix(VALUE self, VALUE rb_pattern);
VALUE vanitygen_ext_generate(VALUE self, VALUE rb_patterns, VALUE rb_options);

void Init_vanitygen_ext() {
    VALUE vanitygen = rb_define_module("Vanitygen");
    VALUE ext = rb_define_module_under(vanitygen, "Ext");

    rb_define_singleton_method(ext, "difficulty_prefix", vanitygen_ext_difficulty_prefix, 1);
    rb_define_singleton_method(ext, "generate", vanitygen_ext_generate, 2);

    init_rbsym();
}
