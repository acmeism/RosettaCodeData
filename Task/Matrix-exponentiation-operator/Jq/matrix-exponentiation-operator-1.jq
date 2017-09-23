# produce an array of length n that is 1 at i and 0 elsewhere
def indicator(i;n): [range(0;n) | 0] | .[i] = 1;

# Identity matrix:
def identity(n): reduce range(0;n) as $i ([]; . + [indicator( $i; n )] );

def direct_matrix_exp(n):
  . as $in
  | if n == 0 then identity($in|length)
    else reduce range(1;n) as $i ($in; . as $m | multiply($m; $in))
    end;

def matrix_exp(n):
  if n < 4 then direct_matrix_exp(n)
  else . as $in
  | ((n|2)|floor) as $m
  | matrix_exp($m) as $ans
  | multiply($ans;$ans) as $ans
  | (n - (2 * $m) ) as $residue
  | if $residue == 0 then $ans
    else matrix_exp($residue) as $residue
    | multiply($ans; $residue )
    end
  end;
