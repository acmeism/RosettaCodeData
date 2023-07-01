#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Random_sentence_from_book
use warnings;

my $book = do { local (@ARGV, $/) = 'waroftheworlds.txt'; <> };
my (%one, %two);

s/^.*?START OF THIS\N*\n//s, s/END OF THIS.*//s,
  tr/a-zA-Z.!?/ /c, tr/ / /s for $book;

my $qr = qr/(\b\w+\b|[.!?])/;
$one{$1}{$2}++, $two{$1}{$2}{$3}++ while $book =~ /$qr(?= *$qr *$qr)/g;

sub weightedpick
  {
  my $href = shift;
  my @weightedpick = map { ($_) x $href->{$_} } keys %$href;
  $weightedpick[rand @weightedpick];
  }

sub sentence
  {
  my @sentence = qw( . ! ? )[rand 3];
  push @sentence, weightedpick( $one{ $sentence[0] } );
  push @sentence, weightedpick( $two{ $sentence[-2] }{ $sentence[-1] } )
    while $sentence[-1] =~ /\w/;
  shift @sentence;
  "@sentence\n\n" =~ s/\w\K (?=[st]\b)/'/gr =~ s/ (?=[.!?]\n)//r
    =~ s/.{60,}?\K /\n/gr;
  }

print sentence() for 1 .. 10;
