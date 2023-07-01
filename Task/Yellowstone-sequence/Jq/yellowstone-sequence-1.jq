# jq optimizes the recursive call of _gcd in the following:
def gcd(a;b):
  def _gcd:
    if .[1] != 0 then [.[1], .[0] % .[1]] | _gcd else .[0] end;
  [a,b] | _gcd ;

# emit the yellowstone sequence as a stream
def yellowstone:
  1,2,3,
  ({ a: [2, 3],                               # the last two items only
     b: {"1":  true, "2": true, "3" : true},  # a record, to avoid having to save the entire history
     start: 4 }
   | foreach range(1; infinite) as $n (.;
       first(
          .b as $b
     	  | .start = first( range(.start;infinite) | select($b[tostring]|not) )
          | foreach range(.start; infinite) as $i (.;
              .emit = null
              | ($i|tostring) as $is
              | if .b[$is] then .
              # "a(n) is relatively prime to a(n-1) and is not relatively prime to a(n-2)"
              elif (gcd($i; .a[1]) == 1) and (gcd($i; .a[0]) > 1)
              then .emit = $i
              | .a = [.a[1], $i]
              | .b[$is] = true
              else .
              end;
              select(.emit)) );
       .emit ));
