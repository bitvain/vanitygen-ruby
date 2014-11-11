#include "rbsym.h"

VALUE rbsym_address;
VALUE rbsym_wif;

void init_rbsym() {
    rbsym_address = ID2SYM(rb_intern("address"));
    rbsym_wif = ID2SYM(rb_intern("wif"));
}
