def array($init): [range(0; .) | $init];

# Test if input is a one-character string holding a digit
def isDigit:
  type=="string" and length==1 and explode[0] as $c | (48 <= $c and $c <= 57);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def generate($n; $i; $c):
  if $n <= 1 then "'n' must be more than 1." | error
  else {   s: ($n|array(array(""))),
         dir: "right",
           y: (($n/2)|floor) }
  | .x = if ($n % 2 == 0) then .y - 1 else .y end  # shift left for even n
  | reduce range($i; $n * $n + $i) as $j (.;
      .s[.y][.x] = (
            if $j | is_prime
	    then (if $c|isDigit then $j|lpad(4) else "  \($c) " end)
	    else " ---"
	    end)
      | if .dir == "right"
        then if (.x <= $n - 1 and .s[.y - 1][.x] == "" and $j > i) then .dir = "up" else . end
        elif .dir == "up"
        then if (.s[.y][.x - 1] == "") then .dir = "left" else . end
        elif .dir == "left"
        then if (.x == 0 or .s[.y + 1][.x] == "") then .dir = "down" else . end
        elif .dir == "down"
        then if (.s[.y][.x + 1] == "") then .dir = "right" else . end
        else .
	end
     | if   .dir == "right" then .x += 1
       elif .dir == "up"    then .y += -1
       elif .dir == "left"  then .x += -1
       elif .dir == "down"  then .y += 1
       else .
       end )
   | .s[] | join(" ")
   end ;

# with digits
generate(9; 1; "0"), "",

# with *
generate(9; 1; "*")
