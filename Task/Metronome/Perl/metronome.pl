use Time::HiRes qw(sleep gettimeofday);

local $| = 1;    # autoflush

my $beats_per_minute = shift || 72;
my $beats_per_bar    = shift || 4;

my $i         = 0;
my $duration  = 60 / $beats_per_minute;
my $base_time = gettimeofday() + $duration;

for (my $next_time = $base_time ; ; $next_time += $duration) {
    if ($i++ % $beats_per_bar == 0) {
        print "\nTICK";
    }
    else {
        print " tick";
    }
    sleep($next_time - gettimeofday());
}
