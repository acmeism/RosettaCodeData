def isColorful:
  def digits: [tostring | explode[] | [.] | implode | tonumber];

  if . < 0 then false
  elif . < 10 then true
  else . as $n
  | digits as $digits
  | if any($digits[]; . == 0 or . == 1) then false
    else ($digits|unique) as $set
    | ($digits|length) as $dc
    | if ($set|length) < $dc then false
      else label $out
      | foreach range(2; $dc) as $k ({$set};
          foreach range(0; $dc-$k+1) as $i (.;
            (reduce range($i; $i+$k) as $j (1; . *  $digits[$j])) as $prod
            | if .set|index($prod) then .return = 0, break $out
              else .set += [$prod]
	      end ;
	    . );
	  select(.return) ) // null
      | if .return == 0 then false else true end
      end
    end
  end;

# Emit a stream of colorfuls in range(a;b)
def colorfuls(a;b):
  range(a;b) | select(isColorful);
