def zeckendorf:
  # rfibs(n) returns an array of fibonnaci numbers up to n,
  # beginning with 1, 2, ..., in reverse order
  def rfibs(n):
    # input: [f(i-2), f(i-1)]
    [1,1] | [recurse( if .[1] >= n then empty
                      else [.[1], add]
                      end ) | .[1]] | reverse;

  . as $n
  # [n, rfibs, digit ]
  | [$n, rfibs($n), "" ]
  | [ recurse( .[0] as $n | .[1] as $f
               | if ($f|length) == 0 then empty
                 else
                   $f[0] as $next
                 | if $n >= $next then [ ( $n - $next), $f[1:], "1"]
		   else [ $n, $f[1:], "0"]
                   end
                 end )
      | .[2] ]
  | if .[1] == "0" then .[2:] else . end  # remove leading 0 if any
  | join("") ;
