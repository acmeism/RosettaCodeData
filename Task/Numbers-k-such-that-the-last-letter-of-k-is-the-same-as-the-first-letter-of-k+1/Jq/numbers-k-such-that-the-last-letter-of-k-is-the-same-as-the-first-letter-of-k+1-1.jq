# The following may be omitted if using the C implementation of jq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def rpad($len): tostring | ($len - length) as $l | . + (" " * $l);

# tabular print
def tprint(columns; wide):
  reduce _nwise(columns) as $row ("";
     . + ($row|map(lpad(wide)) | join(" ")) + "\n" );

# If cond then emit f and use that value to recurse
def whilst(cond; f): def r: select(cond) | f | (., r); r;

# Input: a positive or negative number for which tostring prints with only characters from [-.0-9]
# Output: the name of the number, e.g. "zero" for 0
# An error is raised if the above-mentioned requirement is not met.
def number2name:

  def __small:  [
  "zero", "one", "two", "three", "four", "five", "six",  "seven", "eight", "nine", "ten", "eleven",
  "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"  ];

  def __tens: ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];

  def __illions: [
    "", " thousand", " million", " billion"," trillion", " quadrillion", " quintillion",
    " sextillion", " septillion", " octillion", " nonillion", "decillion" ];

  . as $n
  | if tostring | test("[eE]") then "number2name cannot handle \(.)" | error else . end
  | false   as $_uk   # United Kingdom mode
  | "minus" as $_neg
  | "point" as $_point
  | {f: "",
     and: (if $_uk then "and " else "" end) }
  | if $n < 0
    then .t = $_neg + " "
     | .n = - $n
    else .n = $n
    end
  |  if (.n | (. != floor))
     then .f = (.n | tostring | sub("^[0-9]*[.]";""))
     | .n |= trunc
     else .
     end
  | if .n < 20
    then .t += __small[.n]
    elif .n < 100
    then .t +=  __tens[(.n/10)|floor]
    | (.n % 10) as $s
    | if $s > 0 then .t += "-" + __small[$s] else . end
    elif .n < 1000
    then .t += __small[(.n/100)|floor] + " hundred"
    | (.n % 100) as $s
    | if $s > 0 then .t += " " + .and + ($s|number2name) else . end
    else .sx = ""
    | .i = 0
    | until (.n <= 0;
        (.n % 1000) as $p
        | .n |= ((./1000)|floor)
        | if $p > 0
             then .ix = ($p|number2name) + __illions[.i]
          | if .sx != "" then .ix += " " + .sx else . end
          | .sx = .ix
          else .
             end
        | .i += 1)
     | .t += .sx
    end
  | if .f != ""
    then .t += " " + $_point
    | reduce (.f | explode[] | [.] | implode | tonumber) as $d
           (.; .t += " \(__small[$d])" )
    else .
    end
  | .t ;

# Draws a horizontal bar chart on the terminal representing an array
# of numerical 'data', which must be non-negative, for example:

# Title
# --------------------------------------------------
# a   □ 0
# bb  ■■■■■■■■■■■■■■■■■■■■■■ 1
# ccc ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 2
# --------------------------------------------------

# 'labels' is a list of the corresponding text for each bar.
# If 'rjust' is true then the labels are right-justified within their maximum length,
# otherwise they are left-justified.
# 'width' is the desired total width of the chart in characters.
# 'symbol' is the character to be used to draw each bar,
# 'symbol2' is used to represent scaled non-zero data and 'symbol3' zero data which
# would otherwise be blank. The actual data is printed at the end of each bar.
#
def barChart ($title; $width; $labels; $data; $rjust; $symbol; $symbol2; $symbol3):

  def times($n): if $n > 0 then . * $n else "" end;
  def n: if isinfinite then "∞" else tostring end;

  ($labels|length) as $barCount
  | if ($data|length) != $barCount then "Mismatch between labels and data." | error else . end
  | ($labels | map(length) | max) as $maxLabelLen
  | ($labels
     | if $rjust
       then map( lpad( $maxLabelLen ) )
       else map( rpad( $maxLabelLen ) )
       end ) as $labels
  | ($data|max) as $maxData
  | ($data|map(if isinfinite then 1 else tostring|length end)|max) as $maxDataLength
  | ($width - $maxLabelLen - $maxDataLength - 2) as $maxLen  # maximum length of a bar
  | ($data | map( if isinfinite then $maxLen else ((. * $maxLen / $maxData)|floor) end)) as $scaledData
  | ( "-" * ([$width, ($title|length)] | max)) as $dashes
  | $title,
    $dashes,
    (range(0; $barCount) as $i
     | ($symbol | times($scaledData[$i]))
       | if . == "" then (if $data[$i] > 0 then $symbol2 else $symbol3 end) else . end
       | "\($labels[$i]) \(.) \($data[$i]|n)" ),
    $dashes ;

# Convenience version of the above function using default symbols:
def barChart($title; $width; $labels; $data; $rjust):
    barChart($title; $width; $labels; $data; $rjust; "■"; "◧"; "□");

# Convenience version using right justification for labels.
def barChart($title; $width; $labels; $data):
    barChart($title; $width; $labels; $data; true; "■"; "◧"; "□");
