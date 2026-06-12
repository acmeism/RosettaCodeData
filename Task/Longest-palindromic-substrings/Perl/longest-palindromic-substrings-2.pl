use strict;
use warnings;
use feature 'bitwise';

#@ARGV = 'pi.dat'; # uncomment to use this file or add filename to command line

my $forward = lc do { local $/; @ARGV ? <> : <DATA> };
$forward =~ s/\W+//g;

my $range = 10;
my $backward = reverse $forward;
my $length = length $forward;
my @best = {"''" => 0};
my $len;
for my $i ( 1 .. $length - 2 )
  {
  do
    {
    my $right = substr $forward, $i, $range;
    my $left = substr $backward, $length - $i, $range;
    ( $right ^. $left ) =~ /^\0\0+/ and                                # evens
      ($len = 2 * length $&) >= $#best and
      $best[ $len ]{substr $forward, $i - length $&, $len}++;
    ( $right ^. "\0" . $left ) =~ /^.(\0+)/ and                        # odds
      ($len = 1 + 2 * length $1) >= $#best and
      $best[ $len ]{substr $forward, $i - length $1, $len}++;
    } while $range < $#best and $range = $#best;
  }
print "Longest Palindrome ($#best) : @{[ keys %{ $best[-1] } ]}\n";

__DATA__
this data borrowed from raku...

Never odd or even
Was it a car or a cat I saw?
Too bad I hid a boot
I, man, am regal - a German am I
toot
Warsaw was raw
