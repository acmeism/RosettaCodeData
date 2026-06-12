#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/A*_search_algorithm
use warnings;
use List::AllUtils qw( nsort_by );

sub distance
  {
  my ($r1, $c1, $r2, $c2) = split /[, ]/, "@_";
  sqrt( ($r1-$r2)**2 + ($c1-$c2)**2 );
  }

my $start = '0,0';
my $finish = '7,7';
my %barrier = map {$_, 100}
  split ' ', '2,4 2,5 2,6 3,6 4,6 5,6 5,5 5,4 5,3 5,2 4,2 3,2';
my %values = ( $start, 0 );
my @new = [ $start, 0 ];
my %from;
my $mid;
while( ! exists $values{$finish} and @new )
  {
  my $pick = (shift @new)->[0];
  for my $n ( nsort_by { distance($_, $finish) } # heuristic
    grep !/-|8/ && ! exists $values{$_},
    glob $pick =~ s/\d+/{@{[$&-1]},$&,@{[$&+1]}}/gr
    )
    {
    $from{$n} = $pick;
    $values{$n} = $values{$pick} + ( $barrier{$n} // 1 );
    my $new = [ $n, my $dist = $values{$n} ];
    my $low = 0; # binary insertion into @new (the priority queue)
    my $high = @new;
    $new[$mid = $low + $high >> 1][1] <= $dist
      ? ($low = $mid + 1) : ($high = $mid) while $low < $high;
    splice @new, $low, 0, $new; # insert in order
    }
  }

my $grid = "s.......\n" . ('.' x 8 . "\n") x 7;
substr $grid, /,/ * $` * 9 + $', 1, 'b' for keys %barrier;
my @path = my $pos = $finish; # the walkback to get path
while( $pos ne $start )
  {
  substr $grid, $pos =~ /,/ ? $` * 9 + $' : die, 1, 'x';
  unshift @path, $pos = $from{$pos};
  }
print "$grid\nvalue $values{$finish}  path @path\n";
