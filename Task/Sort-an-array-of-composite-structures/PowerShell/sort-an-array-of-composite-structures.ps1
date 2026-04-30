$list = @{
"def" = "one"
"abc" = "two"
"jkl" = "three"
"abcdef" = "four"
"ghi" = "five"
"ghijkl" = "six"
 }
 $list.GetEnumerator() | sort {-($PSItem.Name).length}, Name
