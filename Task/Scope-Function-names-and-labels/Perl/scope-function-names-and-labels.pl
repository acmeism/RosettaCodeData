no warnings 'redefine';

sub logger { print shift . ": Dicitur clamantis in deserto." };   # discarded

logger('A');                                                      # can use before defined
HighLander::logger('B');                                          # ditto, but referring to another package

package HighLander {
logger('C');
sub logger { print shift . ": I have something to say.\n" };       # discarded
sub down_one_level {
    sub logger { print shift . ": I am a man, not a fish.\n" };    # discarded
    sub down_two_levels {
        sub logger { print shift . ": There can be only one!\n" }; # routine for 'Highlander' package
    }
}
logger('D');
}

logger('E');
sub logger {
   print shift . ": This thought intentionally left blank.\n"      # routine for 'main' package
};
