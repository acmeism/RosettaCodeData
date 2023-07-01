# Include the utilities e.g. by
# include "random-latin-squares.utilities" {search: "."};

# Select an element at random from [range(0;$n)] - column($j)
def candidate($j):
  (.[0] | length) as $n
  | [range(0;$n)] - column($j)
  | .[length|prn];

# Input: the first row or rows of a Latin Square
def extend:
  # The input to ext should be several rows of a Latin Square
  # optionally followed by a candidate for an additional row.
  def ext:
  .[0] as $first
  | length as $length
  | ($first|length) as $n
  | .[-1] as $last
  | if ($last|length) < $n # then extend the last row
    then ( ([range(0;$n)] - column($last|length)) - $last) as $candidates
    | .[:$length-1] as $good
    | ($candidates|length) as $cl

    # if we can complete the row, then there is no need for another backtrack point!
    | if $cl == 1 and ($last|length) == $n - 1
      then ($good + [ $last + $candidates]) | ext # n.b. or use `extend` to speed things up at the cost of more bias
      else
         if $cl == 1 then ($good + [ $last + $candidates]) | ext
         elif $cl == 0
         then empty
         else ($candidates[$cl | prn] as $add
            | ($good + [$last + [$add]]) | ext)
         end
      end
    elif length < $n then ((. + [[candidate(0)]]) | ext)
    else .
    end;
    # If at first you do not succeed ...
    first( repeat( ext ));

# Generate a Latin Square.
# The input should be an integer specifying its size.
def latinSquare:
  . as $n
  | if $n <= 0 then []
    else
    [ [range(0; $n)] | knuthShuffle]
    | extend
    end ;

# If the input is a positive integer, $n, generate and print an $n x $n Latin Square.
# Otherwise, simply echo it.
def printLatinSquare:
  if type == "number"
  then latinSquare
  | .[] | map(lpad(3)) | join(" ")
  else .
  end;

"Five", 5, "\nFive", 5, "\nTen", 10, "\nForty", 40
| printLatinSquare
'
