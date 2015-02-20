use strict;
use warnings;

use constant EXIT_FAILURE => 1;
use constant EXIT_SUCCESS => 0;

sub amb {
   exit(EXIT_FAILURE) if !@_;
   for my $word (@_) {
      my $pid = fork;
      die $! unless defined $pid;
      return $word if !$pid;
      my $wpid = waitpid $pid, 0;
      die $! unless $wpid == $pid;
      exit(EXIT_SUCCESS) if $? == EXIT_SUCCESS;
   }
   exit(EXIT_FAILURE);
}

sub joined {
   my ($join_a, $join_b) = @_;
   substr($join_a, -1) eq substr($join_b, 0, 1);
}

my $w1 = amb(qw(the that a));
my $w2 = amb(qw(frog elephant thing));
my $w3 = amb(qw(walked treaded grows));
my $w4 = amb(qw(slowly quickly));

amb() unless joined $w1, $w2;
amb() unless joined $w2, $w3;
amb() unless joined $w3, $w4;

print "$w1 $w2 $w3 $w4\n";
exit(EXIT_SUCCESS);
