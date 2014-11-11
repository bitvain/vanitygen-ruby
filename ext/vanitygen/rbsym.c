#include "rbsym.h"

VALUE rbsym_address;
VALUE rbsym_wif;
VALUE rbsym_case_insensitive;
VALUE rbsym_continuous;
VALUE rbsym_only_one;

void init_rbsym() {
    rbsym_address = ID2SYM(rb_intern("address"));
    rbsym_wif = ID2SYM(rb_intern("wif"));
    rbsym_case_insensitive = ID2SYM(rb_intern("case_insensitive"));
    rbsym_continuous = ID2SYM(rb_intern("continuous"));
    rbsym_only_one = ID2SYM(rb_intern("only_one"));
}
