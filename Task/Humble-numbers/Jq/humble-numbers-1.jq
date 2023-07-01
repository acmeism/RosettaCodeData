# Input: a positive integer
# Output: true iff the input is humble
def humble:
  . as $i
  | if   ($i < 2) then true
    elif ($i % 2 == 0) then ($i / 2 | floor) | humble
    elif ($i % 3 == 0) then ($i / 3 | floor) | humble
    elif ($i % 5 == 0) then ($i / 5 | floor) | humble
    elif ($i % 7 == 0) then ($i / 7 | floor) | humble
    else false
    end;

def task($digits; $count):
  {len: 0, i:0, count: 0}
  | until( .len > $digits;
      .i += 1
      | if (.i|humble)
        then .len = (.i | tostring | length)
        | if .len <= $digits
	  then .humble[.len] += 1
          | if .count < $count then .count += 1 | .humbles += [.i] else . end
	  else .
	  end
	else .
	end)

  | "First \($count):", .humbles,
    "Distribution of the number of decimal digits up to \($digits) digits:",
     (.humble | range(1;length) as $i | "  \($i):  \(.[$i])") ;

task(6; 50)
