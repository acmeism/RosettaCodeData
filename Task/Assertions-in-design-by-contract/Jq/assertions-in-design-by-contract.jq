include "rc-assert" {search: "."};  # or use the -L command-line option

def averageOfAbsolutes:
  . as $values
  # pre-condition
  | assert(type == "array" and length > 0 and all(type=="number");
           "input to averageOfAbsolutes should be a non-empty array of numbers.")
  | (map(length) | add/length) as $result
  # post-condition
  | assert($result >= 0;
           $__loc__ + { msg: "Average of absolute values should be non-negative."} )
  | $result;

[1, 3], ["hello"]
| averageOfAbsolutes
