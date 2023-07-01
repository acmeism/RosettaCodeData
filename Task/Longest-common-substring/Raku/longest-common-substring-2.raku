sub substrings ($s)       { (flat (0..$_ X 1..$_).grep:{$_ ≥ [+] @_}).map: { $s.substr($^a, $^b) } given $s.chars }
sub infix:<LCS>($s1, $s2) { ([∩] ($s1, $s2)».&substrings).keys.sort(*.chars).tail }

my $first  = 'thisisatest';
my $second = 'testing123testing';
say "The longest common substring between '$first' and '$second' is '{$first LCS $second}'.";
