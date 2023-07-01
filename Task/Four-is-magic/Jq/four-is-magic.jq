def small: ["zero", "one", "two", "three", "four", "five", "six",  "seven", "eight", "nine", "ten", "eleven",
            "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];

def tens: ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];

def illions: ["", " thousand", " million", " billion"," trillion", " quadrillion", " quintillion"];

def say:
  {n: ., t: ""}
  | if .n < 0
    then .t = "negative " | .n = -.n
    else . end
  | if .n < 20
    then .t += small[.n]
    elif .n < 100
    then .t += tens[(.n/10)|floor]
    | .s = .n % 10
    | if (.s > 0) then .t +=  "-" + small[.s] else . end
    elif .n < 1000
    then .t += small[(.n/100)|floor] + " hundred"
    | .s = .n % 100
    | if .s > 0 then .t += " " + (.s|say) else . end
    else .sx = ""
    | .i = 0
    | until(.n == 0;
        .p = .n % 1000
        | .n = (.n / 1000 |floor)
        | if (.p > 0)
          then .ix = (.p|say) + illions[.i]
          | if (.sx != "") then .ix +=  " " + .sx else . end
          | .sx = .ix
          else .
	  end
        | .i += 1 )
   | .t += .sx
   end
   | .t;

def capitalize:
  .[:1] as $x
  | ($x | ascii_upcase) as $X
  | if $x == $X then . else $X + .[1:] end;

def fourIsMagic:
  {n: ., s: (say | capitalize)}
  | .t = .s
  | until(.n == 4;
      .n = (.s|length)
      | .s = (.n | say)
      | .t +=  " is " + .s + ", " + .s )
  | .t + " is magic." ;

(0, 4, 6, 11, 13, 75, 100, 337, -164,  9007199254740991)
| fourIsMagic
