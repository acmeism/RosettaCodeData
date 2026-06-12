def square_perimeter_matrix:
  [range(0; .) | 1] as $top
  | [1, (range(0; .-2) | 0), 1] as $two
  | [$top, (range(0; .-2)|$two), $top];

def display:
  map(join(" ")) | join("\n");
