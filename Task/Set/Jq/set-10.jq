# If A and B are sets, then A-B is emitted
def difference(A;B):
  (A|length) as $al
  | (B|length) as $bl
  | if $al == 0 then [] elif $bl == 0 then A
    else
      reduce range(0; $al + $bl) as $k
        ( [0, 0, []];
          .[0] as $i | .[1] as $j
          | if $i < $al and $j < $bl then
              if A[$i] == B[$j] then [ $i+1, $j+1,  .[2] ]
              elif  A[$i] < B[$j] then [ $i+1, $j, .[2] + [A[$i]] ]
              else [ $i , $j+1, .[2] ]
              end
            elif $i < $al then [ $i+1, $j,  .[2] + [A[$i]] ]
            else .
            end
         ) | .[2]
    end ;
