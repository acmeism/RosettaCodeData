my @sorted_strings = sort -> $x { [ $x.chars, $x.lc ] }, @strings;
