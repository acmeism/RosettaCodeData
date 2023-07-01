def zeckendorf:
  def fibs($n):
    # input: [f(i-2), f(i-1)]
    [1,1] | [recurse(select(.[1] < $n) | [.[1], add]) | .[1]] ;

  # Emit an array of 0s and 1s corresponding to the Zeckendorf encoding
  # $f should be the relevant Fibonacci numbers in increasing order.
  def loop($f):
    [ recurse(. as [$n, $ix]
              | select( $ix > -1 )
              | $f[$ix] as $next
              | if $n >= $next
	        then [$n - $next, $ix-1, 1]
                else [$n, $ix-1, 0]
                end )
      | .[2] // empty ]
    # remove any superfluous leading 0:
    # remove leading 0 if any unless length==1
    | if length>1 and .[0] == 0 then .[1:] else . end ;

  # state: [$n, index_in_fibs, digit ]
  fibs(.) as $f
  | [., ($f|length)-1]
  | loop($f)
  | join("") ;
