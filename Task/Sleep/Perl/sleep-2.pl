use Time::HiRes qw( usleep nanosleep );

$microseconds = <>;
print "Sleeping...\n";
usleep $microseconds;
print "Awake!\n";

$nanoseconds = <>;
print "Sleeping...\n";
nanosleep $nanoseconds;
print "Awake!\n";
