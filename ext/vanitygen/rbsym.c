#include "rbsym.h"

VALUE rbsym_address;
VALUE rbsym_wif;
VALUE rbsym_case_insensitive;
VALUE rbsym_continuous;
VALUE rbsym_only_one;
VALUE rbsym_regex;
VALUE rbsym_regexp;
VALUE rbsym_threads;

void init_rbsym() {
    rbsym_address = ID2SYM(rb_intern("address"));
    rbsym_wif = ID2SYM(rb_intern("wif"));
    rbsym_case_insensitive = ID2SYM(rb_intern("case_insensitive"));
    rbsym_continuous = ID2SYM(rb_intern("continuous"));
    rbsym_only_one = ID2SYM(rb_intern("only_one"));
    rbsym_regex = ID2SYM(rb_intern("regex"));
    rbsym_regexp = ID2SYM(rb_intern("regexp"));
    rbsym_threads = ID2SYM(rb_intern("threads"));
}
