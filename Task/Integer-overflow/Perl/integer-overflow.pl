#include <stdio.h>

<lang perl>
use strict;
use warnings;
use integer;
use feature 'say';

say("Testing 64-bit signed overflow:");
say(-(-9223372036854775807-1));
say(5000000000000000000+5000000000000000000);
say(-9223372036854775807 - 9223372036854775807);
say(3037000500 * 3037000500);
say((-9223372036854775807-1) / -1);
