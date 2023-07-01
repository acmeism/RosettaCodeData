#!/usr/bin/perl

use strict; # see https://rosettacode.org/wiki/Hunt_the_Wumpus
use warnings;
use List::Util qw( shuffle );
$| = 1;

my %tunnels = qw(A BKT B ACL C BDM D CEN E DFO F EGP G FHQ H GIR I HJS
  J IKT K AJL L BKM M CLN N DMO O ENP P FOQ Q GPR R HQS S IRT T AJS);
my ($you, $wumpus, $bat1, $bat2, $pit1, $pit2) = shuffle keys %tunnels;
my $arrows = 5;
print "\nTo shoot, enter a 's' and upper case letter of the desired tunnel.
To move, just enter the upper case letter of the desired tunnel.\n";

while( 1 )
  {
  my @adj = split //, my $adj = $tunnels{$you};
  print "\nYou are in room $you and see three tunnels: @adj\n";
  $adj =~ /$bat1|$bat2/ and print "You hear a rustling.\n";
  $adj =~ /$pit1|$pit2/ and
    print "You feel a cold wind blowing from a nearby cavern.\n";
  $adj =~ $wumpus and print "You smell something terrible nearby.\n";
  print "(m)ove or (s)hoot (tunnel) : ";
  defined($_ = <>) or exit;
  if( /s.*([$adj])/ ) # shoot
    {
    $1 eq $wumpus and exit !print "\nYou killed the Wumpus and won the game.\n";
    $wumpus = substr $wumpus . $tunnels{$wumpus}, rand 4, 1;
    $wumpus eq $you and die "\nYou were eaten by a Wumpus and lost the game.\n";
    --$arrows or die "\nYou ran out of arrows and lost the game.\n";
    }
  elsif( /([$adj])/ ) # move
    {
    $you = $1;
    $wumpus eq $you and die "\nYou were eaten by a Wumpus and lost the game.\n";
    "$pit1$pit2" =~ $you and
      die "\nYou fell into a bottomless pit and lost the game.\n";
    "$bat1$bat2" =~ $you and (($you) = shuffle
      grep !/$you|$wumpus|$pit1|$pit2|$bat1|$bat2/, keys %tunnels),
      print "\nA giant bat has carried you to room $you.\n";
    }
  else { print "I don't understand :(\n"; }
  }
