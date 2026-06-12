use strict;
use warnings;

print "Longest Palindrome For $_ = @{[ longestpalindrome($_) ]}\n"
  for qw(babaccd rotator reverse forever several palindrome abaracadabra);

sub longestpalindrome
  {
  my @best = {"''" => 0};
  pop =~ /(.+) .? (??{reverse $1}) (?{ $best[length $&]{$&}++ }) (*FAIL)/x;
  keys %{pop @best};
  }
