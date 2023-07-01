# index/1 returns the index or null,
# so the jq test "if index(_) then ...." can be used
# without any type conversion.

"abcd" | index( "bc")
#=> 1
