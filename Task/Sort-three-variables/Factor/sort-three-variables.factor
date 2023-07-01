USING: arrays io kernel prettyprint sequences sorting ;
IN: rosetta-code.sort-three

: sort3 ( b c a -- a b c ) 3array natural-sort first3 ;

"lions, tigers, and"
"bears, oh my!"
"(from the \"Wizard of OZ\")"
sort3 [ print ] tri@

77444 -12 0 sort3 [ . ] tri@
