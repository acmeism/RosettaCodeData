# transpose a possibly jagged matrix
def transpose:
  if . == [] then []
  else (.[1:] | transpose) as $t
  | .[0] as $row
  | reduce range(0; [($t|length), (.[0]|length)] | max) as $i
      ([]; . + [ [ $row[$i] ] + $t[$i] ])
  end;

# left/right/center justification of strings:
def ljust(width): . + " " * (width - length);

def rjust(width): " " * (width - length) + .;

def center(width):
  (width - length) as $pad
  | if $pad <= 0 then .
    else ($pad / 2 | floor) as $half
    | $half * " " + . + ($pad-$half) * " "
    end ;

# input: a single string, which includes newlines to separate lines, and $ to separate phrases;
# method must be "left" "right" or anything else for central justification.
def format(method):
  def justify(width):
    if   method == "left"  then ljust(width)
    elif method == "right" then rjust(width)
    else center(width)
    end;

  # max_widths: input: an array of strings, each with "$" as phrase-separator;
  # return the appropriate column-wise maximum lengths
  def max_widths:
    map(split("$") | map(length))
    | transpose | map(max) ;

  split("\n") as $input
  | $input
  | (max_widths | map(.+1)) as $widths
  | map( split("$") | . as $line | reduce range(0; length) as $i
      (""; . + ($line[$i]|justify($widths[$i])) ))
  | join("\n")
;
