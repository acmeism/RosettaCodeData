#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/A*_search_algorithm
use warnings; # extra credit
use List::AllUtils qw( sum );

my $start = <<END;
087
654
321
END
my $finish = <<END;
123
456
780
END

my @tiles = $finish =~ /[1-9a-z]/g;
my $width = index $start, "\n";
my $gap = qr/.{$width}/s;
my $mod = $width + 1;
my %rc = map {$_, int($_ / $mod) . ',' . ($_ % $mod)} 0 .. length($start) - 2;
my %finishrc = map { $_, [ split /,/, $rc{index $finish, $_} ] } @tiles;
my %found = ( $start, 1 );
my @new = [ $start, heuristic($start) ]; # a priority queue
my %from;
my $mid;
while( ! exists $found{$finish} and @new )
  {
  my $pick = (shift @new)->[0];
  for my $n ( grep ! exists $found{$_},
    $pick =~ s/0(\w)/${1}0/r,         # up
    $pick =~ s/(\w)0/0$1/r,           # down
    $pick =~ s/0($gap)(\w)/$2${1}0/r, # left
    $pick =~ s/(\w)($gap)0/0$2$1/r,   # right
    )
    {
    $found{$n} = $from{$n} = $pick;
    my $new = [ $n, my $dist = heuristic( $n ) ];
    my $low = 0; # binary insertion into @new (the priority queue)
    my $high = @new;
    $new[$mid = $low + $high >> 1][1] <= $dist
      ? ($low = $mid + 1) : ($high = $mid) while $low < $high;
    splice @new, $low, 0, $new; # insert in order
    }
  }

#use Data::Dump 'dd'; dd \%found;
my $count = keys %found;
exists $found{$finish} or die "no solution found with $count\n";
my @path = my $pos = $finish; # the walkback to get path
unshift @path, $pos = $from{$pos} while $pos ne $start;
my $steps = @path - 1;
my $states = keys %found;
#print "$_\n" for @path;
my (undef, $w) = split ' ', qx(stty size);
while( @path )
  {
  my @section = splice @path, 0, int( $w / ($mod + 1) );
  while( $section[0] )
    {
    s/(.*)\n/ print "$1  "; ''/e for @section;
    print "\n";
    }
  print "\n";
  }
print "steps: $steps  states: $states\n";

sub heuristic
  {
  my $from = shift;
  sum map
    {
    my ($r1, $c1) = split /,/, $rc{index $from, $_};
    my ($r2, $c2) = @{ $finishrc{$_} };
    abs($r1 - $r2) + abs($c1 - $c2)
    } @tiles;
  }
