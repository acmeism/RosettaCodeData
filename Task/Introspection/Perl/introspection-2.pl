#$bloop = -123;   # uncomment this line to see the difference
no strict 'refs'; # referring to variable by name goes against 'strict' pragma
if (defined($::{'bloop'})) {print abs(${'bloop'})} else {print "bloop isn't defined"};
