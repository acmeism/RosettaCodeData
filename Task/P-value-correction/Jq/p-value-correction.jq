### For gojq
# Require $n > 0
def nwise($n):
  def _n: if length <= $n then . else .[:$n] , (.[$n:] | _n) end;
  if $n <= 0 then "nwise: argument should be non-negative" else _n end;

### Generic functions

def array($n): . as $in | [range(0;$n)|$in];

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def rpad($len): tostring | ($len - length) as $l | . + (" " * $l);

def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;

# tabular print
def tprint($columns; $width):
  reduce _nwise($columns) as $row ("";
     . + ($row|map(lpad($width)) | join(" ")) + "\n" );

# Emit the permutation p such that [range(0;length) as $i | .[$p[$i]]] is sorted
def sort_index:
  [range(0;length) as $i | [$i, .[$i]]]
  | sort_by(.[1])
  | map(.[0]);


### p-value Corrections

def types: [
    "Benjamini-Hochberg", "Benjamini-Yekutieli", "Bonferroni", "Hochberg",
    "Holm", "Hommel", "Šidák"
];

######################################
# The functions in this section expect
# an array of p-values as input.
######################################

def pFormat($cols):
  map(round(10) | rpad(12)) | tprint($cols; 12);

def check:
  if (length == 0 or min < 0 or max > 1)
  then "p-values must be in the range 0 to 1 inclusive" | error
  else .
  end;

# $dir should be "UP" or "DOWN"
def ratchet($dir):
  { m:  .[0], p: .}
  | if $dir == "UP"
    then reduce range(1; .p|length) as $i (.;
           if (.p[$i] > .m) then  .p[$i] = .m end
           | .m = .p[$i])
    else reduce range(1; .p|length) as $i (.;
           if (.p[$i] < .m) then .p[$i] = .m end
           | .m = .p[$i] )
    end
  | .p
  | map( if . < 1 then .  else 1 end);

# If $dir is "UP" then reverse is called
def schwartzian($mult; $dir):
  length as $size
  | (sort_index | if $dir == "UP" then reverse else . end) as $order
  | ([range(0;$size) as $i | $mult[$i] * .[$order[$i]] ]
     | ratchet($dir)) as $pa
  | ($order | sort_index) as $order2
  | [ range(0; $size) as $i | $pa[$order2[$i]]] ;

# $type should be one of `types`
def adjust($type):
  length as $size
  | if $size == 0 then "The array of p-values cannot be empty." | error end
  | if $type == "Benjamini-Hochberg"
    then
         [range(0;$size) as $i | $size / ($size - $i)] as $mult
         | schwartzian($mult; "UP")

    elif $type == "Benjamini-Yekutieli"
    then (reduce range(1; 1+$size) as $i (0;  . + (1/$i))) as $q
         | [range(0; $size) as $i | $q * $size / ($size - $i)] as $mult
         | schwartzian($mult; "UP")

    elif $type == "Bonferroni"
    then map( [(. * $size), 1] | min)

    elif $type == "Hochberg"
    then
         [range(0;$size) as $i | $i + 1] as $mult
         | schwartzian($mult; "UP")

    elif $type == "Holm"
    then
         [range(0; $size) as $i | $size - $i] as $mult
         | schwartzian($mult; "DOWN")

    elif $type == "Hommel"
    then
         sort_index as $order
         | [range(0; $size) as $i | .[$order[$i]]] as $s
         | [range(0; $size) as $i | $s[$i] * $size / ($i + 1)] as $m
         | ($m | min) as $min
         | { q: ($min | array($size)),
            pa: ($min | array($size)) }
         | reduce range($size-1; 1; -1) as $j (.;
             .lower = (0 | array($size - $j + 1))                # lower indices
             | reduce range(0; .lower|length) as $i (.; .lower[$i] = $i)
             | .upper = (0|array($j - 1))
             | reduce range(0; .upper|length) as $i (.; .upper[$i] = $size - $j + 1 + $i)
             | .qmin = ($j * $s[.upper[0]] / 2)
             | reduce range(1; .upper|length) as $i (.;
                 ($s[.upper[$i]] * $j / (2 + $i)) as $temp
                 | if $temp < .qmin then .qmin = $temp end )
             | reduce range(0; .lower|length) as $i (.;
                 .q[.lower[$i]] = ([.qmin, ($s[.lower[$i]] * $j)] | min) )
             | reduce range(0; .upper|length) as $i (.; .q[.upper[$i]] = .q[$size - $j])
             | reduce range(0; $size) as $i (.; if (.pa[$i] < .q[$i]) then .pa[$i] = .q[$i] end)
           )
         | ($order | sort_index) as $order2
         | [range(0; $size) as $i | .pa[$order2[$i] ]]

    elif $type == "Šidák"
    then map(1 - pow(1 - .; $size) )

    else
        "\nSorry, do not know how to do '\($type)' correction.\n" +
          "Perhaps you want one of the following?\n" +
          (types | map( "  \(.)" ) | join("\n") )
    end;

def adjusted($type):
  "\n\($type)",
  (check | adjust($type) | pFormat(5));

### Example

def pValues: [
    4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
    8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
    4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
    8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
    3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
    1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
    4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
    3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
    1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
    2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
];

pValues | adjusted( types[] )
