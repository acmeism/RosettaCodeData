$haystack.match($needle, :g)».from;  # List of all positions where $needle appears in $haystack
$haystack.indices($needle :overlap); # Also find any overlapping instances of $needle in $haystack
