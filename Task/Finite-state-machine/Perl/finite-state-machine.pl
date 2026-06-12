#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Finite_state_machine
use warnings;

my ($state, $action, %fsm) = 'ready';
while( <DATA> )
  {
  my ($start, $action, $end, $message) = split ' ', $_, 4;
  $fsm{$start}{$action} = { next => $end, message => $message || "\n" };
  }

while( $state ne 'exit' )
  {
  print "in state $state\n";
  do
    {
    ($action) = grep $_ eq 'IMPLICIT', my @actions = sort keys %{$fsm{$state}};
    if( not $action )
      {
      print "Enter ", join(' or ', @actions), " : ";
      chomp($action = uc <STDIN>);
      }
    }
  until $fsm{$state}{$action};
  print $fsm{$state}{$action}{message};
  $state = $fsm{$state}{$action}{next};
  }

# state   input    newstate   displaytext
__DATA__
ready     DEPOSIT  waiting    deposit coins
ready     QUIT     exit
waiting   SELECT   dispense   remove item
waiting   REFUND   refunding  take the refund
dispense  REMOVE   ready      Thank You
refunding IMPLICIT ready
