require 'mkmf'

have_library 'pcre'
have_library 'crypto'
have_library 'm'
have_library 'pthread'

create_makefile 'vanitygen/vanitygen_ext'
