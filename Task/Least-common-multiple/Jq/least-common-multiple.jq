# Define the helper function to take advantage of jq's tail-recursion optimization
def lcm(m; n):
  def _lcm:
    # state is [m, n, i]
    if (.[2] % .[1]) == 0 then .[2] else (.[0:2] + [.[2] + m]) | _lcm end;
  [m, n, m] | _lcm;
