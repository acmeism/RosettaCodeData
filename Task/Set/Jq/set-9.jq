# If A and B are sets, then intersection(A;B) emits their intersection:
def intersection(A;B):
  (A|length) as $al
  | (B|length) as $bl
  | if $al == 0 or $bl == 0 then []
    else
      reduce range(0; $al + $bl) as $k
        ( [0, 0, []];
          .[0] as $i | .[1] as $j
          | if $i < $al and $j < $bl then
              if A[$i] == B[$j] then [ $i+1 , $j+1,  .[2] + [A[$i]]]
              elif  A[$i] < B[$j] then [ $i+1 , $j,  .[2] ]
              else [ $i , $j+1,  .[2] ]
              end
            else .
            end
         ) | .[2]
    end ;
