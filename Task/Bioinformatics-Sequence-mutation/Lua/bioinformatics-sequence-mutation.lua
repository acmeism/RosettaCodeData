math.randomseed(os.time())
bases = {"A","C","T","G"}
function randbase() return bases[math.random(#bases)] end

function mutate(seq)
  local i,h = math.random(#seq), "%-6s %3s at %3d"
  local old,new = seq:sub(i,i), randbase()
  local ops = {
    function(s) h=h:format("Swap", old..">"..new, i) return s:sub(1,i-1)..new..s:sub(i+1) end,
    function(s) h=h:format("Delete", " -"..old, i) return s:sub(1,i-1)..s:sub(i+1) end,
    function(s) h=h:format("Insert", " +"..new, i) return s:sub(1,i-1)..new..s:sub(i) end,
  }
  local weighted = { 1,1,2,3 }
  local n = weighted[math.random(#weighted)]
  return ops[n](seq), h
end

local seq,hist="",{} for i = 1, 200 do seq=seq..randbase() end
print("ORIGINAL:")
prettyprint(seq)
print()

for i = 1, 10 do seq,h=mutate(seq) hist[#hist+1]=h end
print("MUTATIONS:")
for i,h in ipairs(hist) do print("  "..h) end
print()

print("MUTATED:")
prettyprint(seq)
