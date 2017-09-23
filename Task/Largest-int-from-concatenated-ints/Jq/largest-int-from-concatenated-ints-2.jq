def largest_int:
  map(tostring)
  | quicksort( .[0] + .[1] < .[1] + .[0] )
  | reverse | join("") ;
