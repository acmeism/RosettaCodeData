use strict;
use warnings;
use feature 'bitwise';

local (@ARGV, $/) = 'unixdict.txt';
my %anagrams;

for my $word ( sort { length $b <=> length $a } split ' ', <> )
  {
  my $key = join '', sort +split //, $word;
  ($_ ^. $word) =~ /\0/ or exit !print "$_ $word\n" for @{ $anagrams{$key} };
  push @{ $anagrams{$key} }, $word;
  }
