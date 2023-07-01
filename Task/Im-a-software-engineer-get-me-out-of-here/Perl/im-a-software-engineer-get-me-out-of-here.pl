#!/usr/bin/perl

use strict;
use warnings;
use List::Util 'first';

my $w = 0;
my $d = join '', <DATA>;
length > $w and $w = length for split "\n", $d;
$d =~ s/.+/ sprintf "%-${w}s", $& /ge; # padding for single number addressing
$w++;

sub   to_xy { my($i) = shift; '(' . join(',', int ($i/$w), $i%$w) . ')' }
sub from_xy { my($x,$y) = @_; $x * $w + $y }

my @directions = ( 1, -1, -$w-1 .. -$w+1, $w-1 .. $w+1 );

my @nodes;
push @nodes, $-[0] while $d =~ /\d/g;
my %dist = map { $_ => all_destinations($_) } @nodes; # all shortest from-to paths

sub all_destinations
  {
  my @queue = shift;
  my $dd = $d;
  my %to;
  while( my $path = shift @queue )
    {
    my $from = (split ' ', $path)[-1];
    my $steps = substr $dd, $from, 1;
    ' ' eq $steps and next;
    $to{$from} //= $path;
    $steps or next;
    substr $dd, $from, 1, '0';
    for my $dir ( @directions )
      {
      my $next = $from + $steps * $dir;
      next if $next < 0 or $next > length $dd;
      (substr $dd, $next, 1) =~ /\d/ and push @queue, "$path $next";
      }
    }
  return \%to;
  }

my $startpos = from_xy 11, 11;

my @best;
$best[ tr/ // ] .= "\t$_\n" for grep $_, map $dist{$startpos}{$_},
  grep { '0' eq substr $d, $_, 1 } @nodes;
my $short = first { $best[$_] } 0 .. $#best;
my $n = $best[$short] =~ tr/\n//;
print "shortest escape routes ($n) of length $short:\n",
  $best[$short] =~ s/\d+/ to_xy $& /ger;

print "\nshortest from (21,11) to (1,11):\n\t",
  $dist{from_xy 21, 11}{from_xy 1, 11} =~ s/\d+/ to_xy $& /ger, "\n";
print "\nshortest from (1,11) to (21,11):\n\t",
  $dist{from_xy 1, 11}{from_xy 21, 11} =~ s/\d+/ to_xy $& /ger, "\n";

@best = ();
$best[tr/ //] .= "\t$_\n" for map { values %$_ } values %dist;
print "\nlongestshortest paths (length $#best) :\n",
  $best[-1] =~ s/\d+/ to_xy $& /ger;

my @notreach = grep !$dist{$startpos}{$_}, @nodes;
print "\nnot reached from HQ:\n\t@notreach\n" =~ s/\d+/ to_xy $& /ger;

@best = ();
$best[tr/ //] .= "\t$_\n" for values %{ $dist{$startpos} };
print "\nlongest reinforcement from HQ is $#best for:\n",
  $best[-1] =~ s/\d+/ to_xy $& /ger;

__DATA__
         00000
      00003130000
    000321322221000
   00231222432132200
  0041433223233211100
  0232231612142618530
 003152122326114121200
 031252235216111132210
 022211246332311115210
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
 013322444412122123210
 015132331312411123120
 003333612214233913300
  0219126511415312570
  0021321524341325100
   00211415413523200
    000122111322000
      00001120000
         00000
