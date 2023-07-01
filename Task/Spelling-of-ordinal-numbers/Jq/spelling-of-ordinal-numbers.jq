# integer division for precision when using gojq
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def small:
  ["zero", "one", "two", "three", "four", "five", "six",  "seven", "eight", "nine", "ten",
   "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];

def tens:
  ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];

# Up to 1e63 (vigintillion)
def illions:
  ["", " thousand", " million", " billion"," trillion", " quadrillion", " quintillion",
       " sextillion", " septillion", " octillion", " nonillion", " decillion", " undecillion",
       " duodecillion", " tredecillion", " quattuordecillion", " quindecillion",
       " sexdecillion", " septendecillion", " octadecillion", " novemdecillion",
       " vigintillion"
];

def illions($i):
  if $i >= (illions|length) then "\($i * 3) zeros is beyond the scope of this exercise" | error
  else illions[$i]
  end;

def irregularOrdinals: {
    "one":    "first",
    "two":    "second",
    "three":  "third",
    "five":   "fifth",
    "eight":  "eighth",
    "nine":   "ninth",
    "twelve": "twelfth"
};

def check_ok:
  def ieee754:
    9007199254740993==9007199254740992;
  if ieee754
  then if (. > 0 and (. + 1) == .) or  (. < 0 and (. - 1) == .)
       then  "The number \(.) is too large for this platform" | error
       else .
       end
  else .
  end;

# error courtesy of illions/1 if order of magnitude is too large
def say:
  check_ok
  | { t: "", n: .}
  | if .n < 0 then .t = "negative " | .n *= -1 else . end
  | if .n < 20
    then .t += small[.n]
    elif .n < 100
    then .t += tens[.n | idivide(10)]
    | .s = .n % 10
    | if .s > 0 then .t +=  "-" + small[.s] else . end
    elif .n < 1000
    then .t += small[.n | idivide(100)] + " hundred"
    | .s = .n % 100
    | if .s > 0 then .t +=  " " + (.s|say) else . end
    else .sx = ""
    | .i = 0
    | until (.n <= 0;
          .p = .n % 1000
          | .n = (.n | idivide(1000))
          | if .p > 0
            then .ix = (.p|say) + illions(.i)
            | if .sx != "" then .ix += " " + .sx else . end
            | .sx = .ix
            else .
            end
          | .i += 1 )
    | .t += .sx
    end
    | .t ;

def sayOrdinal:
  {n: ., s: say}
  | .r = (.s | explode | reverse | implode)
  | .i1 = (.r|index(" "))
  | if .i1 then .i1 = (.s|length) - 1 - .i1 else . end
  | .i2 = (.r|index("-"))
  | if .i2 then .i2 = (.s|length) - 1 - .i2 else . end
  # Set .i to 0 iff there was no space or hyphen:
  | .i = (if .i1 or .i2 then 1 + ([.i1,.i2] | max) else 0 end)
  # Now s[.i:] is the last word:
  | irregularOrdinals[.s[.i:]] as $x
  | if $x then .s[:.i] + $x
    elif .s | endswith("y")
    then .s[:-1] + "ieth"
    else .s + "th"
    end;

# Sample inputs
(1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456,
 8007006005004003,
 9007199254740991,
 2e12,
 9007199254740993,   # too large for jq

 # 1e63 is vigintillion so gojq should be able to handle 999 * 1e63
 999000000000000000000000000000000000000000000000000000000000000000,

 # ... but not 1000 vigintillion
 1000000000000000000000000000000000000000000000000000000000000000000
 )
| "\(lpad(10)) => \(sayOrdinal)"
