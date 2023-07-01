substr($haystack, 0, $needle.chars) eq $needle  # True if $haystack starts with $needle
substr($haystack, *-$needle.chars) eq $needle   # True if $haystack ends with $needle
