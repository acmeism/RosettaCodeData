# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

# Input: an array
# Output: an array, being a selection of $k elements from . chosen with replacement
def prns($k):
  . as $in
  | length as $n
  | [range(0; $k) | $in[$n|prn]];

def knuthShuffle:
  length as $n
  | if $n <= 1 then .
    else {i: $n, a: .}
    | until(.i ==  0;
        .i += -1
        | (.i + 1 | prn) as $j
        | .a[.i] as $t
        | .a[.i] = .a[$j]
        | .a[$j] = $t)
    | .a
    end;

# Generate a single password of length $len >= 4;
# certain confusable characters are only allowed iff $simchars is truthy.
def passgen($len; $simchars):
  def stoa: explode | map([.]|implode);

  if $len < 4 then "length must be at least 4" | error
  else
    { DIGIT: ("0123456789" | stoa),
      UPPER: [range(65;91) | [.] | implode],  # A-Z
      LOWER: [range(97;123) | [.] | implode], # a-z
      OTHER: ("!\"#$%&'()*+,-./:;<=>?@[]^_{|}~" | stoa) }
  | if $simchars|not
    then .DIGIT |= . - ["0", "1", "2", "5"]
    |    .UPPER |= . - ["O", "I", "Z", "S"]
    |    .LOWER |= . -  ["l"]
    end
  | (reduce (.DIGIT, .UPPER, .LOWER, .OTHER) as $set ([];
                 . + ($set | prns(1)))) +
    (.DIGIT + .UPPER + .LOWER + .OTHER | prns($len - 4))
  | knuthShuffle
  | join("")
  end ;

def passgen($len):
  passgen($len; true);

# Generate a stream of $npass passwords, each of length $len;
# certain confusable characters are only allowed iff $simchars is truthy.
def passgen($len; $npass; $seed; $simchars):
  if ($seed | type) == "number" and $seed > 0 then $seed | prn else null end
  | range(0; $npass)
  | passgen($len; $simchars) ;


### Examples:
"Without restriction:", passgen(12; 5; null; true),
"",
"Certain confusable characters are disallowed:", passgen(12; 5; null; false)
