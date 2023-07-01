def repeat(f; n):
  # state: [count, in]
  def r:
    if .[0] >= n then empty else (.[1] | f), (.[0] += 1 | r) end;
  [0, .] | r;
