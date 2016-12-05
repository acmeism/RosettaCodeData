 "Derangements:",
 ([range(1;5)] | derangements),
 "",
 "Counted vs Computed Derangments:",
 (range(1;10) as $i | "\($i): \(count( [range(0;$i)] | derangements)) vs \($i|subfact)"),
 "",
 "Computed approximation to !20 (15 significant digits): \(20|subfact)"
