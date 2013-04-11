--returns an iterator over the first n copies of the look-and-say sequence
function lookandsayseq(n)
  local t = {1}
  return function()
    local ret = {}
    for i, v in ipairs(t) do
      if t[i-1] and v == t[i-1] then
        ret[#ret - 1] = ret[#ret - 1] + 1
      else
        ret[#ret + 1] = 1
        ret[#ret + 1] = v
      end
    end
    t = ret
    n = n - 1
    if n > 0 then return table.concat(ret) end
  end
end
for i in lookandsayseq(10) do print(i) end
