function reverse()
  local ch = io.read(1)
  if ch:find("%w") then
    local rc = reverse()
    io.write(ch)
    return rc
  end
  return ch
end

function forward()
  ch = io.read(1)
  io.write(ch)
  if ch == "." then return false end
  if not ch:find("%w") then
    ch = reverse()
    if ch then io.write(ch) end
    if ch == "." then return false end
  end
  return true
end

while forward() do end
