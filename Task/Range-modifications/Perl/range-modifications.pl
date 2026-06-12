#!/usr/bin/perl

use strict;
use warnings;

my $ranges;

while( <DATA> )
  {
  my ($cmd) = /(\S.*\S)/ or print "\n";
  $ranges = /Start with "(.*)"/ ? $1 :
    /add (\d+)/ ? add($1) :
    /remove (\d+)/ ? remove($1) :
    $ranges;
  $cmd and printf qq(%35s  ->  "%s"\n), $cmd, $ranges;
  }

sub add
  {
  my $n = shift;
  s/^$/$n-$n/                                              # empty
    or s/-@{[$n-1]},@{[$n+1]}\b//                          # join 2 ranges
    or s/\b@{[$n+1]}-/$n-/                                 # lower start
    or s/-@{[$n-1]}\b/-$n/                                 # raise end
    or s/^(?=(\d+)-(??{$n < $1 ? '' : 'X'}))/$n-$n,/       # add front
    or s/-(\d+)\K$(??{$1 < $n ? '' : 'X'})/,$n-$n/         # add end
    or s/\b(\d+),(\d+)\b(??{$1 < $n-1 && $n < $2+1 ? '' : 'X'
      })/$1,$n-$n,$2/                                      # add middle
    for $ranges;
  $ranges;
  }

sub remove
  {
  my $n = shift;
  s/^$n-$n,?|,$n-$n\b//                                    # single item
    or s/\b$n(?=-)/$n+1/e                                  # first from range
    or s/-\K$n\b/$n-1/e                                    # last from range
    or s/\b(\d+)-(\d+)\b(??{$1 < $n && $n < $2 ? '' : 'X'
      })/$1-@{[$n-1]},@{[$n+1]}-$2/                        # split range
    for $ranges;
  $ranges;
  }

__DATA__
   Start with "1-3,5-5"
       add 77
       add 79
       add 78
       remove 77
       remove 78
       remove 79

   Start with "1-3,5-5"
       add 1
       remove 4
       add 7
       add 8
       add 6
       remove 7

   Start with "1-5,10-25,27-30"
       add 26
       add 9
       add 7
       remove 26
       remove 9
       remove 7
