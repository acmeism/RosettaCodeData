#!/usr/bin/perl
use strict;
use warnings;

{
  my @tartaglia ;
  sub tartaglia {
      my ($x,$y) = @_;
      if ($x == 0 or $y == 0)  { $tartaglia[$x][$y]=1 ; return 1};
      my $ret ;
      foreach my $yps (0..$y){
        $ret += ( $tartaglia[$x-1][$yps] || tartaglia($x-1,$yps) );
      }
      $tartaglia[$x][$y] = $ret;
      return $ret;
  }
}
sub tartaglia_row {
    my $y = shift;
    my $x = 0;
    my @row;
    $row[0] = &tartaglia($x,$y+1);
    foreach my $pos (0..$y-1) {push @row, tartaglia(++$x,--$y)}
    return @row;
}


for (0..5) {print join ' ', tartaglia_row($_),"\n"}
print "\n\n";


print tartaglia(3,3),"\n";
my @third = tartaglia_row(5);
print "@third\n";
