-- Return a table of the first n values of the Van Eck sequence
function vanEck (n)
  local seq, foundAt = {0}
  while #seq < n do
    foundAt = nil
    for pos = #seq - 1, 1, -1 do
      if seq[pos] == seq[#seq] then
        foundAt = pos
        break
      end
    end
    if foundAt then
      table.insert(seq, #seq - foundAt)
    else
      table.insert(seq, 0)
    end
  end
  return seq
end

-- Show the set of values in table t from key numbers lo to hi
function showValues (t, lo, hi)
  for i = lo, hi do
    io.write(t[i] .. " ")
  end
  print()
end

-- Main procedure
local sequence = vanEck(1000)
showValues(sequence, 1, 10)
showValues(sequence, 991, 1000)
