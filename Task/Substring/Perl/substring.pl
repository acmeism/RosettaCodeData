my $str = 'abcdefgh';
print substr($str, 2, 3), "\n"; # Returns 'cde'
print substr($str, 2), "\n"; # Returns 'cdefgh'
print substr($str, 0, -1), "\n"; #Returns 'abcdefg'
print substr($str, index($str, 'd'), 3), "\n"; # Returns 'def'
print substr($str, index($str, 'de'), 3), "\n"; # Returns 'def'
