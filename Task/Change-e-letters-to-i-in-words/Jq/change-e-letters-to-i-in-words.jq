def e2i($dict):
  select(index("e"))
  | gsub("e";"i")
  | select($dict[.]);

INDEX( inputs; . )
| . as $dict
| keys[] # keys_unsorted[] if using jq would be faster
| select(length>6)
| . as $w
| e2i($dict)
| "\($w) → \(.)"
