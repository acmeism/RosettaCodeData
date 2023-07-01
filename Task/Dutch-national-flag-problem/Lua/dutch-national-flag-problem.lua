-- "1. Generate a randomized order of balls.."
math.randomseed(os.time())
N, balls, colors = 10, {}, { "red", "white", "blue" }
for i = 1, N do balls[i] = colors[math.random(#colors)] end
-- "..ensuring that they are not in the order of the Dutch national flag."
order = { red=1, white=2, blue=3 }
function issorted(t)
  for i = 2, #t do
    if order[t[i]] < order[t[i-1]] then return false end
  end
  return true
end
local function shuffle(t)
  for i = #t, 2, -1 do
    local j = math.random(i)
    t[i], t[j] = t[j], t[i]
  end
end
while issorted(balls) do shuffle(balls) end
print("RANDOM:  "..table.concat(balls,","))

-- "2. Sort the balls in a way idiomatic to your language."
table.sort(balls, function(a, b) return order[a] < order[b] end)

-- "3. Check the sorted balls are in the order of the Dutch national flag."
print("SORTED:  "..table.concat(balls,","))
print(issorted(balls) and "Properly sorted." or "IMPROPERLY SORTED!!")
