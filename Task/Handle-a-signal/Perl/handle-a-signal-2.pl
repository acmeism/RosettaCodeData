use 5.010;
use AnyEvent;
my $start = AE::time;
my $exit = AE::cv;
my $int = AE::signal 'INT', $exit;
my $n;
my $num = AE::timer 0, 0.5, sub { say $n++ };
$exit->recv;
say " interrupted after ", AE::time - $start, " seconds";
