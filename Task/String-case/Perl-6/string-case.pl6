my $word = "alpha BETA" ;
say uc $word;         # all uppercase (subroutine call)
say $word.uc;         # all uppercase (method call)
# from now on we use only method calls as examples
say $word.lc;         # all lowercase
say $word.tc;         # first letter titlecase
say $word.tclc;       # first letter titlecase, rest lowercase
say $word.tcuc;       # first letter titlecase, rest uppercase
say $word.wordcase;   # capitalize each word
