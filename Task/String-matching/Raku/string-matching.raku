# Using string methods:

$haystack.starts-with($needle)  # True if $haystack starts with $needle
$haystack.contains($needle)     # True if $haystack contains $needle
$haystack.ends-with($needle)    # True if $haystack ends with $needle

# Using regexes:

so $haystack ~~ /^ $needle  /  # True if $haystack starts with $needle
so $haystack ~~ /  $needle  /  # True if $haystack contains $needle
so $haystack ~~ /  $needle $/  # True if $haystack ends with $needle

# Using substr:

substr($haystack, 0, $needle.chars) eq $needle  # True if $haystack starts with $needle
substr($haystack, *-$needle.chars) eq $needle   # True if $haystack ends with $needle

# Bonus task:

$haystack.match($needle, :g)».from;  # List of all positions where $needle appears in $haystack
$haystack.indices($needle :overlap); # Also find any overlapping instances of $needle in $haystack
