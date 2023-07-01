# If n is a non-negative integer,
# then emit a stream of (n + 1) terms: ., f, f|f, f|f|f, ...
def repeatedly(f; n):
  # state: [count, in]
  def r:
    if .[0] < 0 then empty
    else .[1], ([.[0] - 1, (.[1] | f)] | r)
    end;
  [n, .] | r;
