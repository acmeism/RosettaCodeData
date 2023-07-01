def clash($row2; $row1):
  any(range(0;$row2|length); $row1[.] == $row2[.]);

# Input is a row; stream is a stream of rows
def clash(stream):
  . as $row | any(stream; clash($row; .)) ;

# Emit a stream of latin squares of size .
def latin_squares:
  . as $n

  # Emit a stream of arrays of permutation of 1 .. $n inclusive, and beginning with $i
  | def permutations_beginning_with($i):
      [$i] + ([range(1; $i), range($i+1; $n + 1)] | permutations);

  # input: an array of rows, $rows
  # output: a stream of all the permutations starting with $i
  #         that are permissible relative to $rows
  def filter_permuted($i):
    . as $rows
    | permutations_beginning_with($i)
    | select( clash($rows[]) | not ) ;

  # input: an array of the first few rows (at least one) of a latin square
  # output: a stream of possible immediate-successor rows
  def next_latin_square_row:
    filter_permuted(1 + .[-1][0]);

  # recursion makes completing a latin square a snap
  def complete_latin_square:
     if length == $n then .
     else next_latin_square_row as $next
     | . + [$next] | complete_latin_square
     end;

  [[range(1;$n+1)]]
  | complete_latin_square ;
