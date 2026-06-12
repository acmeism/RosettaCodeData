def count(s): reduce s as $_ (0; .+1);

def minDelta: 1;

def getMaxPrice: $prices | max;

def getPrangeCount($min; $max):
  count( $prices[] | select($min <= . and . <= $max) ) ;

def get5000($prices; $min; $max; $n):
  { count: getPrangeCount($min; $max),
    delta: (($max - $min) / 2),
    $max }
  | until(.count == $n or .delta < minDelta/2;
      .max = (( if .count > $n then .max - .delta else .max + .delta end)|floor)
      | .count = getPrangeCount($min; .max)
      | .delta /= 2 )
  | [.max, .count] ;

def getAll5000($min; $max; $n):
   { mc: get5000($prices; $min; $max; $n)}
   | .pmax = .mc[0]
   | .pcount = .mc[1]
   | .res = [[$min, .pmax, .pcount]]
   | until(.pmax >= $max;
       .pmin = .pmax + 1
       | .mc = get5000($prices; .pmin; $max; $n)
       | .pmax = .mc[0]
       | .pcount = .mc[1]
       | if .pcount == 0 then "Price list from \(.pmin) has too many with same price." | error
         else .res += [[.pmin, .pmax, .pcount]]
         end )
   | .res ;

def trim: sub("^ +";"") | sub(" +$";"");

def display($res; $numPrices; $actualMax; $approxBinSize):
   "Using \($numPrices) items with prices from 0 to \($actualMax):",
   "Split into \($res|length) bins of approx \($approxBinSize) elements:",
   ($res[] as [$min, $max, $n]
    | (if $max > $actualMax then $actualMax else $max end) as $mx
    | "   From \($min) to \($mx) with \($n) items" ) ;

def repl(approxBinSize):
  ($prices|length) as $numPrices
  | getMaxPrice as $actualMax
  | getAll5000(0; $actualMax; approxBinSize) as $res
  | def r:
     trim
     | . as $line
     | if startswith("get_max_price") then {getMaxPrice: getMaxPrice}
       else (scan(" *get_prange_count *[(]([0-9]+) *, *([0-9]+) *[)]")
             | map(tonumber) as [$min, $max]
	     | {"getPrangeCount": {$min, $max, count: getPrangeCount($min; $max)}})
	    // {error: $line}
       end;
  display($res; $numPrices; $actualMax; approxBinSize),
  (inputs | r);

# The approximate bin size
repl(5000)
