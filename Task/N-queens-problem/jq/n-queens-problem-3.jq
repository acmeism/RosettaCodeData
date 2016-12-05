# permutations of 0 .. (n-1)
def permutations(n):
  # Given a single array, generate a stream by inserting n at different positions:
  def insert(m;n):
     if m >= 0 then (.[0:m] + [n] + .[m:]), insert(m-1;n) else empty end;

  if n==0 then []
  elif n == 1 then [1]
  else
    permutations(n-1) | insert(n-1; n)
  end;

def count(g): reduce g as $i (0; .+1);
