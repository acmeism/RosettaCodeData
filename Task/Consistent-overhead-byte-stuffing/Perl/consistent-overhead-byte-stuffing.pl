#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Consistent_overhead_byte_stuffing
use warnings;

my @data = map { pack 'H*', tr/ //dr } split /\n/, <<END;
00
00 00
00 11 00
11 22 00 33
11 22 33 44
11 00 00 00
00 00 00 00 00 00
33 33 33 33 33 33 33
END
push @data, ( " " x $_ ) for 1269 .. 1272;

sub showbytes
  {
  my @bytes = map /../g, unpack 'H*', pop;
  print "@_: ",
    "@bytes\n" =~ s!(\w\w)\K(( \1){7,})! 'x' . (1 + length($2) / 3) !ger;
  }

my $marker = "\0"; # the byte that is eliminated from string

sub encode
  {
  return join '',
    (map chr(1 + length) . $_, # prepend length
    map /.{1,254}|^\z/gs,      # break up long sections
    split /\Q$marker/, shift, -1), $marker;
  }

sub decode
  {
  (local $_, my $keep, my $answer) = (shift, 0, '');
  while( /\G[^\Q$marker\E]/g ) # advance over count byte
    {
    my $len = -1 + ord $&;     # length of data block
    $answer .= $marker x $keep . (/\G[^\Q$marker\E]{$len}/g, $&);
    $keep = $len < 254;        # was split on marker, not size
    }
  return $answer;
  }

for my $original ( @data )
  {
  showbytes 'original', $original;
  showbytes ' encoded', my $answer = encode $original;
  showbytes ' decoded', my $decoded = decode $answer;
  $original eq $decoded or die "MISMATCH";
  print "\n";
  }
