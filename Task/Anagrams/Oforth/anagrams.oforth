import: mapping
import: collect
import: quicksort

: anagrams
| m |
   "unixdict.txt" File new groupBy( #sort )
   dup sortBy( #[ second size] ) last second size ->m
   filter( #[ second size m == ] )
   apply ( #[ second .cr ] )
;
