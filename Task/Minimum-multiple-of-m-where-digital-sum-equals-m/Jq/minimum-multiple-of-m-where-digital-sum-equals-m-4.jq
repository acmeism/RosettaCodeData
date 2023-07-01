def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

nwise(
  range(1; 71) | minimum_integer_multiple;
  10)
| map(lpad(9)) | join(" ")
