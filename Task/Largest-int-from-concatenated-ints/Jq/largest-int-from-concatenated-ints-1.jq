def largest_int:

  def pad(n):  . + (n - length) * .[length-1:];

  map(tostring)
  | (map(length) | max) as $max
  | map([., pad($max)])
  | sort_by( .[1] )
  | map( .[0] ) | reverse | join("") ;

# Examples:
([1, 34, 3, 98, 9, 76, 45, 4],
 [54, 546, 548, 60])  | largest_int
