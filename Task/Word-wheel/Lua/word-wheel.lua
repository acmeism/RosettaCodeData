LetterCounter = {
  new = function(self, word)
    local t = { word=word, letters={} }
    for ch in word:gmatch(".") do t.letters[ch] = (t.letters[ch] or 0) + 1 end
    return setmetatable(t, self)
  end,
  contains = function(self, other)
    for k,v in pairs(other.letters) do
      if (self.letters[k] or 0) < v then return false end
    end
    return true
  end
}
LetterCounter.__index = LetterCounter

grid = "ndeokgelw"
midl = grid:sub(5,5)
ltrs = LetterCounter:new(grid)
file = io.open("unixdict.txt", "r")
for word in file:lines() do
  if #word >= 3 and word:find(midl) and ltrs:contains(LetterCounter:new(word)) then
    print(word)
  end
end
