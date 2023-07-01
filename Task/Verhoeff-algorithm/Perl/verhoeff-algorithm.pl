#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Verhoeff_algorithm
use warnings;

my @inv = qw(0 4 3 2 1 5 6 7 8 9);

my @d = map [ split ], split /\n/, <<END;
0 	1 	2 	3 	4 	5 	6 	7 	8 	9
1 	2 	3 	4 	0 	6 	7 	8 	9 	5
2 	3 	4 	0 	1 	7 	8 	9 	5 	6
3 	4 	0 	1 	2 	8 	9 	5 	6 	7
4 	0 	1 	2 	3 	9 	5 	6 	7 	8
5 	9 	8 	7 	6 	0 	4 	3 	2 	1
6 	5 	9 	8 	7 	1 	0 	4 	3 	2
7 	6 	5 	9 	8 	2 	1 	0 	4 	3
8 	7 	6 	5 	9 	3 	2 	1 	0 	4
9 	8 	7 	6 	5 	4 	3 	2 	1 	0
END

my @p = map [ split ], split /\n/, <<END;
0 	1 	2 	3 	4 	5 	6 	7 	8 	9
1 	5 	7 	6 	2 	8 	3 	0 	9 	4
5 	8 	0 	3 	7 	9 	6 	1 	4 	2
8 	9 	1 	6 	0 	4 	3 	5 	2 	7
9 	4 	5 	3 	1 	2 	6 	8 	7 	0
4 	2 	8 	6 	5 	7 	3 	9 	0 	1
2 	7 	9 	3 	8 	0 	6 	4 	1 	5
7 	0 	4 	6 	9 	1 	3 	2 	5 	8
END

my $debug;

sub generate
  {
  local $_ = shift() . 0;
  my $c = my $i = 0;
  my ($n, $p);
  $debug and print "i ni d(c,p(i%8,ni)) c\n";
  while( length )
    {
    $c = $d[ $c ][ $p = $p[ $i % 8 ][ $n = chop ] ];
    $debug and printf "%d%3d%7d%10d\n", $i, $n, $p, $c;
    $i++;
    }
  return $inv[ $c ];
  }

sub validate { shift =~ /(\d+)(\d)/ and $2 == generate($1) }

for ( 236, 12345, 123456789012 )
  {
  print "testing $_\n";
  $debug = length() < 6;
  my $checkdigit = generate($_);
  print "check digit for $_ is $checkdigit\n";
  $debug = 0;
  for my $cd ( $checkdigit, 9 )
    {
    print "$_$cd is ", validate($_ . $cd) ? '' : 'not ', "valid\n";
    }
  print "\n";
  }
