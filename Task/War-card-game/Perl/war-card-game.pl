#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/War_Card_Game
use warnings;
use List::Util qw( shuffle );

my %rank;
@rank{ 2 .. 9, qw(t j q k a) } = 1 .. 13; # for winner
local $_ = join '', shuffle
  map { my $f = $_; map $f.$_, qw( S H C D ) } 2 .. 9, qw( a t j q k );
substr $_, 52, 0, "\n"; # split deck into two parts
my $war = '';
my $cnt = 0;
$cnt++ while print( /(.*)\n(.*)/ && "one: $1\ntwo: $2\n\n" ),
  s/^((.).)(.*)\n((?!\2)(.).)(.*)$/ my $win = $war; $war = ''; # capture
    $rank{$2} > $rank{$5} ? "$3$1$4$win\n$6" : "$3\n$6$4$1$win" /e
  ||
  s/^(.{4})(.*)\n(.{4})(.*)$/ print "WAR!!!\n\n"; $war .= "$1$3";
    "$2\n$4" /e; # tie means war
print "player '", /^.{10}/ ? 'one' : 'two', "' wins in $cnt moves\n";
