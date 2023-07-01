def cocktailSort:
  def swap(i;j): .[i] as $t | .[i] = .[j] | .[j] = $t;

  def shake(stream):
    reduce stream as $i
      (.[0]=false;
       .[1] as $A
       | if $A[ $i ] > $A[ $i+1 ] then
           [true, ($A|swap( $i; $i+1 ))]
         else .
         end);

  (length - 2) as $lm2
  # state: [swapped, A]
  | [true, .]
  | until( .[0]|not;
           shake(range(0; $lm2 + 1))
           | if .[0] then
   	       # for each i in length( A ) - 2 down to 0
               shake( $lm2 - range(0; $lm2 + 1))
	     else .
	     end )
  | .[1];
