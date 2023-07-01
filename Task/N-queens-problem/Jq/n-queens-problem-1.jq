def single_solution_queens(n):
  def q: "♛";
  def init(k): reduce range(0;k) as $i ([]; . + ["."]);
  def matrix(k): init(k) as $row | reduce range(0;k) as $i ([]; . + [$row]);
  def place(stream; i; j):
    # jq indexing is based on offsets but we are using the 1-based formulae:
    reduce stream as $s (.; setpath([-1+($s|i), -1+($s|j)]; q) );
  def even(k):
    if ((k-2) % 6) != 0 then
         place( range(1; 1+(k/2));         .; 2*. )
       | place( range(1; 1+(k/2)); (k/2) + .; 2*. -1 )
    else place( range(1; 1+(k/2));         .; 1 + ((2*. + (k/2) - 3) % k))
       | place( range(1; 1+(n/2)); n + 1 - .; n - ((2*. + (n/2) - 3) % n))
    end;

  matrix(n)                          # the chess board
  | if (n % 2) == 0 then even(n)
    else even(n-1) | .[n-1][n-1] = q
    end;

# Example:
def pp: reduce .[] as $row
  ("";  reduce $row[] as $x (.; . + $x) + "\n");

single_solution_queens(8) | pp
