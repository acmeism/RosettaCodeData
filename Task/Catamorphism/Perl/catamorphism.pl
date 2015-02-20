use List::Util 'reduce';

# note the use of the odd $a and $b globals
print +(reduce {$a + $b} 1 .. 10), "\n";

# first argument is really an anon function; you could also do this:
sub func { $b & 1 ? "$a $b" : "$b $a" }
print +(reduce \&func, 1 .. 10), "\n"
