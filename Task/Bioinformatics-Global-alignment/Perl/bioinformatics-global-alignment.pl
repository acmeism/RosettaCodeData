#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Bioinformatics/global_alignment
use warnings;
use List::Util qw( first uniq );

my @seq = (
  [ qw( TA AAG TA GAA TA ) ],

  [ qw( CATTAGGG ATTAG GGG TA) ],

  [ qw( AAGAUGGA GGAGCGCAUC AUCGCAAUAAGGA ) ],

  [ qw(
  ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT
  GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT
  CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA
  TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC
  AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT
  GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC
  CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT
  TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC
  CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC
  GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT
  TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC
  CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA
  TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA
  ) ],
  );

sub removedups # remove dups and subseqs
  {
  local $_ = join ' ', sort { length $a <=> length $b } split ' ', shift;
  1 while s/\b(\w+) (?=.*\1)//;
  return $_;
  }

for ( @seq )
  {
  local $_ = removedups join ' ', @$_;
  my @queue = $_;
  my @best;

  while( @queue )
    {
    local $_ = shift @queue;
    my @seq = split ' ', $_;
    my @over;
    for my $left ( @seq )
      {
      for my $right ( @seq )
        {
        $left eq $right and next;
        "$left $right" =~ /(.+) \1/ or next;
        my $len = length $1;
        $over[$len] .= "$left $right\n";
        }
      }
    if( @over )
      {
      for my $join ( split /\n/, $over[-1] )
        {
        my ($left, $right) = split ' ', $join;
        my @newseq = grep $_ ne $left && $_ ne $right, @seq; # remove used
        push @queue, removedups "$left $right" =~ s/(.+) (?=\1)//r .
          join ' ', '', @newseq;
        }
      }
    else
      {
      tr/ //d;
      $best[length] .= "$_\n";
      next;
      }
    }

  for ( uniq split /\n/, first {defined} @best )
    {
    printf "\nlength %d - %s\n", length, $_;
    my %ch;
    $ch{$_}++ for /./g;
    use Data::Dump 'dd'; dd \%ch;
    }
  }
