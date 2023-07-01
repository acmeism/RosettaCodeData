  def newCount := counts.fetch(v, fn { 0 }) + 1
  counts[v] := newCount
  maxCount := maxCount.max(newCount)
