#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Go_Fish
use warnings;
use List::Util qw( first shuffle );

my $pat = qr/[atjqk2-9]/; # ranks
my $deck = join '', shuffle map { my $rank = $_; map "$rank$_", qw( S H C D ) }
  qw( a t j q k ), 2 .. 9;

my $mebooks = my $youbooks = 0;

my $me = substr $deck, 0, 2 * 9, '';
my $mepicks = join '', $me =~ /$pat/g;
arrange($me);
$mebooks++ while $me =~ s/($pat).\1.\1.\1.//;
my $you = substr $deck, 0, 2 * 9, '';
my $youpicks = join '', $you =~ /$pat/g;
arrange($you);
$youbooks++ while $you =~ s/($pat).\1.\1.\1.//;

while( $mebooks + $youbooks < 13 )
  {
  play( \$you, \$youbooks, \$youpicks, \$me, \$mebooks, 1 );
  $mebooks + $youbooks == 13 and last;
  play( \$me, \$mebooks, \$mepicks, \$you, \$youbooks, 0 );
  }
print "me $mebooks you $youbooks\n";

sub arrange { $_[0] = join '', sort $_[0] =~ /../g }

sub human
  {
  my $have = shift =~ s/($pat).\K(?!\1)/ /gr;
  local $| = 1;
  my $pick;
  do
    {
    print "You have $have, enter request: ";
    ($pick) = lc(<STDIN>) =~ /$pat/g;
    } until $pick and $have =~ /$pick/;
  return $pick;
  }

sub play
  {
  my ($me, $mb, $lastpicks, $you, $yb, $human) = @_;
  my $more = 1;
  while( arrange( $$me ), $more and $$mb + $$yb < 13 )
    {
#   use Data::Dump 'dd'; dd \@_, "deck $deck";
    if( $$me =~ s/($pat).\1.\1.\1.// )
      {
      print "book of $&\n";
      $$mb++;
      }
    elsif( $$me )
      {
      my $pick = $human ? do { human($$me) } : do
        {
        my %picks;
        $picks{$_}++ for my @picks = $$me =~ /$pat/g;
        my $pick = first { $picks{$_} } split(//, $$lastpicks), shuffle @picks;
        print "pick $pick\n";
        $$lastpicks =~ s/$pick//g;
        $$lastpicks .= $pick;
        $pick;
        };
      if( $$you =~ s/(?:$pick.)+// )
        {
        $$me .= $&;
        }
      else
        {
        print "GO FISH !!\n";
        $$me .= substr $deck, 0, 2, '';
        $more = 0;
        }
      }
    elsif( $deck )
      {
      $$me .= substr $deck, 0, 2, '';
      }
    else
      {
      $more = 0;
      }
    }
  arrange( $$me );
  }
