# mul_inv(a;b) returns x where (a * x) % b == 1, or else null
def mul_inv(a; b):

  # state: [a, b, x0, x1]
  def iterate:
    .[0] as $a | .[1] as $b
    | if $a > 1 then
        if $b == 0 then null
        else ($a / $b | floor) as $q
           | [$b, ($a % $b), (.[3] - ($q * .[2])), .[2]] | iterate
        end
      else .
      end ;

  if (b == 1) then 1
  else [a,b,0,1] | iterate
       | if . == null then .
         else  .[3] | if . <  0 then . + b else . end
         end
  end;

def chinese_remainder(mods; remainders):
  (reduce mods[] as $i (1; . * $i)) as $prod
  | reduce range(0; mods|length) as $i
      (0;
       ($prod/mods[$i]) as $p
       | mul_inv($p; mods[$i]) as $mi
       | if $mi == null then error("nogo: p=\($p) mods[\($i)]=\(mods[$i])")
         else . + (remainders[$i] * $mi * $p)
         end )
  | . % $prod ;
