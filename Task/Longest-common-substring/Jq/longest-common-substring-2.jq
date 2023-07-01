def lcs(a; b):
  matrix(a|length; b|length; 0) as $lengths
  # state: [ $lengths, greatestLength, answer ]
  | [$lengths, 0]
  | reduce range(0; a|length) as $i
      (.;
       reduce range(0; b|length) as $j
         (.;
           if a[$i:$i+1] == b[$j:$j+1] then
            (if $i == 0 or $j == 0 then 1
             else .[0][$i-1][$j-1] + 1
 	     end) as $x
            | .[0] |= set($i; $j; $x)
            | if $x > .[1] then
                .[1] = $x
                | .[2] = a[1+$i - $x : 1+$i] # output
              else .
              end
          else .
          end )) | .[2];
