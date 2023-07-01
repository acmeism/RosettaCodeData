# A control structure, for convenience:
# as soon as "condition" is true, then emit . and stop:
def do_until(condition; next):
  def u: if condition then . else (next|u) end;
  u;

# n is the initial number; every k-th prisoner is removed until m remain.
# Solution by simulation
def josephus(n;k;m):
    reduce range(0;n) as $i ([]; . + [$i])    # Number the prisoners from 0 to (n-1)
    | do_until( length < k or length <= m; .[k:] + .[0:k-1] )
    | do_until( length <= m; (k % length) as $i | .[$i:] + .[0:$i-1] );
