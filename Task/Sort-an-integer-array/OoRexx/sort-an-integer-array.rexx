a = .array~of(4, 1, 6, -2, 99, -12)
say "The sorted numbers are"
say a~sortWith(.numericComparator~new)~makeString
