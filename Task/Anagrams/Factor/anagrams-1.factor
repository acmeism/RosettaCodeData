 "resource:unixdict.txt" utf8 file-lines
 [ [ natural-sort >string ] keep ] { } map>assoc sort-keys
 [ [ first ] compare +eq+ = ] monotonic-split
 dup 0 [ length max ] reduce '[ length _ = ] filter [ values ] map .
