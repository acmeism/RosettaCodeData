# floyd(n) creates an n-row floyd's triangle
def floyd(n):
  def lpad(len): tostring | (((len - length) * " ")  + .);

  # Construct an array of widths.
  # Assuming N is the last integer on the last row (i.e. (n+1)*n/2),
  # the last row has n entries from (1+N-n) through N:
  def widths:
    ((n+1)*n/2) as $N
    | [range(1 + $N - n; $N + 1) | tostring | length];

  # emit line k assuming it starts with the integer "start"
  def line(start; k; widths):
    reduce range(start; start+k) as $i
      (""; . + ($i|lpad(widths[$i - start])) + " ");

  widths as $widths
  | (reduce range(0;n) as $row
      ( [0, ""];   # state: i, string
        (.[0] + 1) as $i | .[1] as $string
        | [ ($i + $row),
            ($string + "\n" + line($i; $row + 1; $widths )) ] )
    | .[1] ) ;
