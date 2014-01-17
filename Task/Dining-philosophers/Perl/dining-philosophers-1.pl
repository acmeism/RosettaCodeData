use threads;
use threads::shared;
my @names = qw(Aristotle Kant Spinoza Marx Russell);

my @forks = ('On Table') x @names;
share $forks[$_] for 0 .. $#forks;

sub pick_up_forks {
   my $philosopher = shift;
   my ($first, $second) = ($philosopher, $philosopher-1);
   ($first, $second) = ($second, $first) if $philosopher % 2;
   for my $fork ( @forks[ $first, $second ] ) {
      lock $fork;
      cond_wait($fork) while $fork ne 'On Table';
      $fork = 'In Hand';
   }
}

sub drop_forks {
   my $philosopher = shift;
   for my $fork ( @forks[$philosopher, $philosopher-1] ) {
      lock $fork;
      die unless $fork eq 'In Hand';
      $fork = 'On Table';
      cond_signal($fork);
   }
}

sub philosopher {
   my $philosopher = shift;
   my $name = $names[$philosopher];
   for my $meal ( 1..5 ) {
      print $name, " is pondering\n";
      sleep 1 + rand 8;
      print $name, " is hungry\n";
      pick_up_forks( $philosopher );
      print $name, " is eating\n";
      sleep 1 + rand 8;
      drop_forks( $philosopher );
   }
   print $name, " is done\n";
}

my @t = map { threads->new(\&philosopher, $_) } 0 .. $#names;
for my $thread ( @t ) {
   $thread->join;
}

print "Done\n";
__END__
