set isPrefix    [string match  $needle* $haystack]
set isContained [string match *$needle* $haystack]
set isSuffix    [string match *$needle  $haystack]
