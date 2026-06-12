# The input should be a non-empty array of integers representing a polynomial.
# The output likewise represents its derivative.
def derivative:
  . as $p
  | if length == 1 then [0]
    else reduce range(0; length-1) as $i (.[1:];
      .[$i] = $p[$i+1] * ($i + 1) )
    end;

def polyPrint:
  def ss: ["\u2070", "\u00b9", "\u00b2", "\u00b3", "\u2074", "\u2075", "\u2076", "\u2077", "\u2078", "\u2079"];
  def digits: tostring | explode[] | [.] | implode | tonumber;
  ss as $ss
  | def superscript:
      if . <= 1 then ""
      else reduce digits as $d (""; . + $ss[$d] )
      end;

  . as $p
  | if length == 1 then .[0] | tostring
    else reduce range(0; length) as $i ([];
        if $p[$i] != 0
	then (if $i > 0 then "x" else "" end) as $x
        | ( if $i > 0 and ($p[$i]|length) == 1
	    then (if $p[$i] == 1 then "" else "-" end)
	    else ($p[$i]|tostring)
	    end ) as $c
	| . + ["\($c)\($x)\($i|superscript)"]
        else . end )
    | reverse
    | join("+")
    | gsub("\\+-"; "-")
    end ;

def task:
  def polys: [ [5], [4, -3], [-1, 6, 5], [-4, 3, -2, 1], [1, 1, 0, -1, -1] ];

  "Example polynomials and their derivatives:\n",
  ( polys[] |  "\(.) -> \(derivative)" ),

  "\nOr in normal mathematical notation:\n",
  ( polys[]
    | "Polynomial : \(polyPrint)",
      "Derivative : \(derivative|polyPrint)\n" ) ;

task
