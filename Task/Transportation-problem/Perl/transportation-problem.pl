use strict;
use warnings;
use feature 'say';
use List::AllUtils qw( max_by nsort_by min );

my $data = <<END;
A=20 B=30 C=10
S=25 T=35
AS=3 BS=5 CS=7
CT=3 BT=2 CT=5
END

my $table = sprintf +('%4s' x 4 . "\n") x 3,
  map {my $t = $_; map "$_$t", '', 'A' .. 'C' } '' , 'S' .. 'T';

my ($cost, %assign) = (0);
while( $data =~ /\b\w=\d/ ) {
  my @penalty;
  for ( $data =~ /\b(\w)=\d/g ) {
    my @all = map /(\d+)/, nsort_by { /\d+/ && $& }
      grep { my ($t, $c) = /(.)(.)=/; $data =~ /\b$c=\d/ and $data =~ /\b$t=\d/ }
      $data =~ /$_\w=\d+|\w$_=\d+/g;
    push @penalty, [ $_, ($all[1] // 0) - $all[0] ];
  }
  my $rc = (max_by { $_->[1] } nsort_by
    { my $x = $_->[0]; $data =~ /(?:$x\w|\w$x)=(\d+)/ && $1 } @penalty)->[0];
  my @lowest = nsort_by { /\d+/ && $& }
    grep { my ($t, $c) = /(.)(.)=/; $data =~ /\b$c=\d/ and $data =~ /\b$t=\d/ }
    $data =~ /$rc\w=\d+|\w$rc=\d+/g;
  my ($t, $c) = $lowest[0] =~ /(.)(.)/;
  my $allocate = min $data =~ /\b[$t$c]=(\d+)/g;
  $table =~ s/$t$c/ sprintf "%2d", $allocate/e;
  $cost += $data =~ /$t$c=(\d+)/ && $1 * $allocate;
  $data =~ s/\b$_=\K\d+/ $& - $allocate || '' /e for $t, $c;
}

say my $result = "cost $cost\n\n" . $table =~ s/[A-Z]{2}/--/gr;
