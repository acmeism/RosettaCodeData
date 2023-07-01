# Sort any array
def selection_sort:
  def swap(i;j): if i == j then . else .[i] as $tmp | .[i] = .[j] | .[j] = $tmp end;
  length as $length
  | reduce range(0; $length) as $currentPlace
      # state: $array
      ( .;
        . as $array
        | (reduce range( $currentPlace; $length) as $check
            # state: [ smallestAt, smallest] except initially [null]
            ( [$currentPlace+1] ;
               if length == 1 or $array[$check] < .[1]
               then [$check, $array[$check] ]
               else .
               end
             )) as $ans
          | swap( $currentPlace; $ans[0] )
          ) ;
