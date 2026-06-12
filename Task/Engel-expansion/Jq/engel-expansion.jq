include "rational" {search: "."};   # see above

# Convert a decimal to a Rational
# Input: a number or numeric string that is NOT expressed in scientific notation
def dec2r:
  def ds2r:
    if test("^-") then .[1:] | ds2r | rminus
    elif test("-") then error
    elif test("e|E") then "dec2r does not yet support scientific notation" | error
    elif index(".")
    then capture("(?<i>[0-9]*)[.](?<j>[0-9]*)")
    | (.j | length) as $j
    | r( (.i + .j) | tonumber; 10 | power($j) )
    else r(tonumber; 1)
    end;

  if type == "number"
  then if . == 0 then r(0;1)
       elif . < 0 then -. | dec2r | rminus
       else tostring | ds2r
       end
  else ds2r
  end;

# Convert a Rational to a simple decimal string, at least in common
# cases of interest for this task
def r2dec:
  def lpad($len): tostring | ($len - length) as $l | ("0" * $l)[:$l] + .;
  def rpad: if length == 0 then "0" else . end;

  # $n is the number of decimal places
  def d($n):
    tostring as $s
    | if $n == 0 then $s + ".0"
      else ($s[-$n:] | lpad($n) | rpad) as $right
      | ($s[: ($s|length) - $n] | rpad) as $left
      | $left + "." + $right
      end;

  . as $in
  | (.d | tostring)
  | length as $dlength
  | if test("^10*$")    then $in.n | d($dlength - 1)
    elif test("^50*$")  then (2 * $in.n) | d($dlength)
    elif test("^20*$")  then (5 * $in.n) | d($dlength)
    elif test("^320*$") then (3125 * $in.n) | d( $dlength + 3)  # 100,000
    elif test("^6250*$") then (16 * $in.n) | d( $dlength + 1)   #  10,000
    else $in
    end;

# itrunc/0 attempts to compute the "trunc" of the input number in such
# a way that gojq will recognize the result as an integer, while
# leveraging the support that both the C and Go implementations have
# for integer literals.
# It is mainly intended for numbers for which the tostring value does NOT contain an exponent.
# The details are complicated because the goal is to provide portability between jq implementations.
#
# Input: a number or a string matching ^[0-9]+([.][0-9]*)$
# Output: as specified by the implementation.
def itrunc:
  if type == "number" and . < 0 then - ((-.) | itrunc)
  else . as $in
  | tostring as $s
  | ($s | test("[Ee]")) as $exp
  | ($s | test("[.]")) as $decimal
  | if ($exp|not) and ($decimal|not) then $s | tonumber # do not simply return $in
    elif ($exp|not) and $decimal then $s | sub("[.].*";"") | tonumber
    else trunc
    | tostring
    | if test("[Ee]")
      then if $exp then "itrunc cannot be used on \($in)" | error end
      else tonumber
      end
    end
  end;

# rtrunc is like trunc but for Rational numbers, though the input may be
# either a number or a Rational.
def rtrunc:
  if type == "number" then r(itrunc;1)
  elif 0 == .n or (0 < .n and .n < .d) then r(0;1)
  elif 0 < .n or (.n % .d == 0) then .d as $d | r(.n | idivide($d)  ; 1)
  else rminus( r( - .n; .d) | rtrunc | rminus; 1)
  end;

# For present purposes it is sufficient to assume .n >= 0
def rceil:
  if .n == .d or .d == 1 then .
  else radd(.; r(1;1))
  | rtrunc
  end;

### Engel expansion
# input: a rational expressed as an ordinary decimal number or a numeric string
# (Scientific notation cannot be used.)
def toEngel:
  . as $x
  | {u: dec2r,
     engel: [] }
  | until(.u.n == 0;
        (.u | rinv | rceil | .n) as $a
        | .engel += [ $a ]
        | .u = rminus( rmult(.u ; r($a;1)) ; r(1;1)) )
  | .engel;

def fromEngel:
  foreach (.[], null) as $e (
    {sum:  r(0;1),
     prod: r(1;1)};
    if $e == null then .emit = .sum
    else .prod = rmult(.prod; r(1; $e))
    | .sum = radd(.sum; .prod)
    end )
  | select(.emit).emit
  | r2dec;

# Input: a rational in the form of a simple decimal such as 3.1 or "3.1"
def task:
   "Rational number : \(.)",
    ( index(".") + 1) as $dix
     | (length - $dix) as $places
     | toEngel as $engel
     | "Engel expansion : \($engel[:30])",
       "Number of terms : \($engel|length)",
       "Back to rational: \($engel | fromEngel)\n"
;

def rats: [
    "3.14159265358979",
    "2.71828182845904",
    "1.414213562373095",
    "7.59375",
    "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211",
    "2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642743",
    "1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927558",
    "25.628906"
];

rats[] | task
