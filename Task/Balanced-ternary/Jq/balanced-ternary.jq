### Generic utilities

# Emit a stream of the constituent characters of the input string
def chars: explode[] | [.] | implode;

# Flip "+" and "-" in the input string, and change other characters to 0
def flip:
  {"+": "-", "-": "+"} as $t
  | reduce chars as $c (""; . + ($t[$c] // "0") );

### Balanced ternaries (BT)

# Input is assumed to be an integer (use `new` if checking is required)
def toBT:
  # Helper - input should be an integer
  def mod3:
    if . > 0 then . % 3
    else ((. % 3) + 3) % 3
    end;

  if . < 0 then - . | toBT | flip
  else if . == 0 then ""
       else mod3 as $rem
       | if   $rem == 0 then (. / 3 | toBT) + "0"
         elif $rem == 1 then (. / 3 | toBT) + "+"
         else                ((. + 1) / 3 | toBT) + "-"
         end
       end
       | sub("^00*";"")
       | if . == "" then "0" end
  end ;

# Input: BT
def integer:
  . as $in
  | length as $len
  | { sum: 0,
      pow: 1 }
  | reduce range (0;$len) as $i (.;
       $in[$len-$i-1: $len-$i] as $c
       | (if $c == "+" then 1 elif $c == "-" then -1 else 0 end) as $digit
       | if $digit != 0 then .sum += $digit * .pow else . end
       | .pow *= 3 )
  | .sum ;

# If the input is a string, check it is a valid BT, and trim leading 0s;
# if the input is an integer, convert it to a BT;
# otherwise raise an error.
def new:
  if type == "string" and all(chars; IN("0", "+", "-"))
  then sub("^00*"; "") | if . == "" then "0" end
  elif type == "number" and trunc == .
  then toBT
  else "'new' given invalid input: \(.)" | error
  end;

# . + $b
def plus($b):
  # Helper functions:
  def at($i): .[$i:$i+1];

  # $a and $b should each be "0", "+" or "-"
  def addDigits2($a; $b):
    if $a == "0" then $b
    elif $b == "0" then $a
    elif $a == "+"
    then if $b == "+" then "+-" else "0" end
    elif $b == "+" then "0" else "-+"
    end;

  def addDigits3($a; $b; $carry):
    addDigits2($a; $b) as $sum1
    | addDigits2($sum1[-1:]; $carry) as $sum2
    | if ($sum1|length) == 1
      then $sum2
      elif ($sum2|length) == 1
      then $sum1[0:1] + $sum2
      else $sum1[0:1]
      end;

  { longer:  (if length > ($b|length) then . else $b end),
    shorter: (if length > ($b|length) then $b else . end) }
  | until ( (.shorter|length) >= (.longer|length); .shorter = "0" + .shorter )
  | .a = .longer
  | .b = .shorter
  | .carry = "0"
  | .sum = ""
  | reduce range(0; .a|length) as $i (.;
      ( (.a|length) - $i - 1) as $place
      | addDigits3(.a | at($place); .b | at($place); .carry) as $digisum
      | .carry = (if ($digisum|length) != 1 then $digisum[0:1] else "0" end)
      | .sum = $digisum[-1:] + .sum )
  | .carry + .sum
  | new;

def minus: flip;

# . - $b
def minus($b): plus($b | flip);

def mult($b):
  (1 | new) as $one
  | (0 | new) as $zero
  | { a: .,
      $b,
      mul: $zero,
      flipFlag: false }
  | if .b[0:1] == "-"  # i.e. .b < 0
    then .b |= minus
    | .flipFlag = true
    end
  | .i = $one
  | .in = 1
  | (.b | integer) as $bn
  | until ( .in > $bn;
      .a as $a
      | .mul |= plus($a)
      | .i |= plus($one)
      | .in += 1 )
  | if .flipFlag then .mul | minus else .mul end ;


### Illustration

def a: "+-0++0+";
def b: -436 | new;
def c:  "+-++-";

  (a | integer) as $an
| (b | integer) as $bn
| (c | integer) as $cn
| ($an * ($bn - $cn)) as $in
| (a | mult( (b | minus(c)))) as $i
| "a = \($an)",
  "b = \($bn)",
  "c = \($cn)",
  "a * (b - c) = \($i) ~ \($in) => \($in|new)"
