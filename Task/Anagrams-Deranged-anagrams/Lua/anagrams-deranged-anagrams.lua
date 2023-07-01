string.tacnoc = function(str) -- 'inverse' of table.concat
  local arr={}
  for ch in str:gmatch(".") do arr[#arr+1]=ch end
  return arr
end

local function deranged(s1, s2)
  if s1==s2 then return false end
  local t1, t2 = s1:tacnoc(), s2:tacnoc()
  for i,v in ipairs(t1) do if t2[i]==v then return false end end
  return true
end

local dict = {}
local f = io.open("unixdict.txt", "r")
for word in f:lines() do
  local ltrs = word:tacnoc()
  table.sort(ltrs)
  local hash = table.concat(ltrs)
  dict[hash] = dict[hash] or {}
  table.insert(dict[hash], word)
end

local answer = { word="", anag="", len=0 }
for _,list in pairs(dict) do
  if #list>1 and #list[1]>answer.len then
    for _,word in ipairs(list) do
      for _,anag in ipairs(list) do
        if deranged(word, anag) then
          answer.word, answer.anag, answer.len = word, anag, #word
        end
      end
    end
  end
end
print(answer.word, answer.anag, answer.len)
