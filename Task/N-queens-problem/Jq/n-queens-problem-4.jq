def queens(n):
  def sums:
  . as $board
  | [ range(0;length) | . + $board[.]]
  | unique | length;

  def differences:
  . as $board
  | [ range(0;length) | . - $board[.]]
  | unique | length;

  def allowable:
    length as $n
    | sums == $n and differences == $n;

  count( permutations(n) | select(allowable) );
