USING: formatting io kernel math math.combinatorics math.ranges
sequences sets ;
IN: rosetta-code.department-numbers

7 [1,b] 3 <k-permutations>
[ [ first even? ] [ sum 12 = ] bi and ] filter

"{ Police, Sanitation, Fire }" print nl
[ "%[%d, %]\n" printf ] each
