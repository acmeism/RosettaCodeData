# $lines specifies the number of lines to display for each eca
def main($lines):
  (90, 30) as $rule
  | "\nRule: \($rule)",
    (limit($lines; eca_infinite("1"; $rule)
     | .[0] as $line
     | ($line|lpad(3)) + " " * ($lines - $line) + (.[1] | tr("01"; ".#") )));

main(25)
