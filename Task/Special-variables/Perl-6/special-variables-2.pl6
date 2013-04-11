 $foo               # ordinary scoping
 $.foo              # object attribute public accessor
 $^foo              # self-declared formal positional parameter
 $:foo              # self-declared formal named parameter
 $*foo              # dynamically overridable global variable
 $?foo              # compiler hint variable
 $=foo              # Pod variable
 $<foo>             # match variable, short for $/{'foo'}
 $!foo              # object attribute private storage
 $~foo              # the foo sublanguage seen by the parser at this lexical spot
