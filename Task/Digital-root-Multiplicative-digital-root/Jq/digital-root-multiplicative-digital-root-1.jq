def do_until(condition; next):
  def u: if condition then . else (next|u) end;
  u;

def mdroot(n):
  def multiply: reduce .[] as $i (1; .*$i);
  # state: [mdr, persist]
  [n, 0]
  | do_until( .[0] < 10;
              [(.[0] | tostring | explode | map(.-48) | multiply), .[1] + 1]
            );

# Produce a table with 10 rows (numbered from 0),
# showing the first n numbers having the row-number as the mdr
def tabulate(n):
  # state: [answer_matrix, next_i]
  def tab:
    def minlength: map(length) | min;
    .[0] as $matrix
    | .[1] as $i
    | if (.[0]|minlength) == n then .[0]
      else (mdroot($i) | .[0]) as $mdr
      | if $matrix[$mdr]|length < n then
          ($matrix[$mdr] + [$i]) as $row
          | $matrix | setpath([$mdr]; $row)
        else $matrix
        end
      | [ ., $i + 1 ]
      | tab
      end;

  [[], 0]  | tab;
