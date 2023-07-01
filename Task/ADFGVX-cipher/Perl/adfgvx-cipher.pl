#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/ADFGVX_cipher
use warnings;
use List::Util qw( shuffle );

my $plaintext = 'ATTACKAT1200AM';
my $keysize = 9;

my $polybius = <<END;
  | A D F G V X
--+------------
A | x x x x x x
D | x x x x x x
F | x x x x x x
G | x x x x x x
V | x x x x x x
X | x x x x x x
END
$polybius =~ s/x/$_/ for my @letters = shuffle "A" .. 'Z' , 0 .. 9;
print "Polybius square =\n\n$polybius\n";
my %char2pair;
@char2pair{ @letters } = glob '{A,D,F,G,V,X}' x 2; # map chars to pairs
my %pair2char = reverse %char2pair;                # map pairs to chars
my ($keyword) = shuffle grep !/(.).*\1/,
  do { local (@ARGV, $/) = 'unixdict.txt'; <> =~ /^.{$keysize}$/gm };
my ($n, @deorder) = 0;
my @reorder = map /.(.+)/, sort map $_ . $n++, split //, $keyword;
@deorder[@reorder] = 0 .. $#reorder;
print "  keyword = $keyword\n\nplaintext = $plaintext\n\n";

my $encoded = encode( $plaintext, \%char2pair, \@reorder );
print "  encoded = $encoded\n\n";

my $decoded = decode( $encoded, \%pair2char, \@deorder );
print "  decoded = $decoded\n";

sub encode
  {
  my ($plain, $c2p, $order) = @_;
  my $len = @$order;
  join ' ', (transpose( $plain =~ s/./$c2p->{$&}/gr =~ /.{1,$len}/g ))[@$order];
  }

sub decode
  {
  my ($encoded, $p2c, $order) = @_;
  (join '', transpose((split ' ', $encoded)[@$order])) =~ s/../$p2c->{$&}/gr;
  }

sub transpose { map join('', map {s/.// ? $& : ''} @_), 1 .. length $_[0] }
