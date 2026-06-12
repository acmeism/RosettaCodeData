# Left-pad with 0s
def lpad($len): tostring | ($len - length) as $l | ("0" * $l) + .;

def expand:
  # The key to success here is reluctance (".*?")
  def cap:
    capture("(?<head>^.*?)[{](?<from>[0-9]+|.)[.][.](?<to>[0-9]+|.)"
    + "([.][.](?<sign>-)?(?<increment>[0-9]))?[}](?<tail>.*)$");

  def ton: if . == null then . else tonumber end;

  # Produce a stream of integers, handling implicit descent.
  # $i and $j should be integers.
  # If $i and $j are distinct, then expand($i;$j;null;null) will include both,
  # otherwise just $i.
  def expand($i; $j; $sign; $increment):
    (if $increment == null then 1 else $increment end) as $inc
    | if $sign == null
      then if $i <= $j
            then range($i; $j + 1;  $inc)
            else range($i; $j - 1; - $inc)
            end
      else [expand($i; $j; null; $increment)] | reverse[]
      end ;

  # Produce a stream of single characters, handling implicit descent
  def explode($x; $y; $sign; $increment):
    ($x|explode[0]) as $x
    | ($y|explode[0]) as $y
    | expand($x; $y; $sign; $increment)
    | [.] | implode;

  # The number of leading 0s of the input string
  def leadingZeros: match("^0*") | .string | length;

  def padding($x; $y):
    ($x | leadingZeros) as $a
    |  ($y | leadingZeros) as $b
    | [if $a > 0 then ($x|length) else 0 end,
       if $b > 0 then ($y|length) else 0 end]
    | max;

  ( cap as $c
    | if ($c.from|test("[0-9]+")) and ($c.to|test("[0-9]+"))
      then  padding($c.from; $c.to) as $padding
      | $c.head
        + ( expand($c.from|tonumber;
                   $c.to|tonumber;
                   $c.sign;
                   $c.increment | ton) | lpad($padding))
        + ($c.tail | expand)
      elif ($c.from|length == 1) and ($c.to|length == 1)
      then $c.head + explode($c.from; $c.to; $c.sign; $c.increment|ton)
        + ($c.tail | expand)
      else ""
      end )
  // . ;

def examples:
    "simpleNumberRising{1..3}.txt",
    "simpleAlphaDescending-{Z..X}.txt",
    "steppedDownAndPadded-{10..00..5}.txt",
    "minusSignFlipsSequence {030..20..-5}.txt",
    "reverseSteppedNumberRising{1..6..-2}.txt",
    "combined-{Q..P}{2..1}.txt",
    "emoji{🌵..🌶}{🌽..🌾}etc",
    "li{teral",
    "rangeless{}empty",
    "rangeless{random}string",
    "mixedNumberAlpha{5..k}",
    "steppedAlphaRising{P..Z..2}.txt",
    "stops after endpoint-{02..10..3}.txt",
    "steppedNumberRising{1..6..2}.txt",
    "steppedNumberDescending{20..9..2}",
    "steppedAlphaDescending-{Z..M..2}.txt",
    "reversedSteppedAlphaDescending-{Z..M..-2}.txt"
;

examples
| "\(.) ->",
  "  \(expand)", ""
