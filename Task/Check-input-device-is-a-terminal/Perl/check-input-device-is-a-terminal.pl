use strict;
use warnings;
use 5.010;
if (-t) {
    say "Input comes from tty.";
}
else {
    say "Input doesn't come from tty.";
}
