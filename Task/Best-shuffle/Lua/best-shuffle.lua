math.randomseed(os.time())

local function shuffle(t)
  for i = #t, 2, -1 do
    local j = math.random(i)
    t[i], t[j] = t[j], t[i]
  end
end

local function bestshuffle(s, r)
  local order, shufl, count = {}, {}, 0
  for ch in s:gmatch(".") do order[#order+1], shufl[#shufl+1] = ch, ch end
  if r then shuffle(shufl) end
  for i = 1, #shufl do
    for j = 1, #shufl do
      if i ~= j and shufl[i] ~= order[j] and shufl[j] ~= order[i] then
        shufl[i], shufl[j] = shufl[j], shufl[i]
      end
    end
  end
  for i = 1, #shufl do
    if shufl[i] == order[i] then
      count = count + 1
    end
  end
  return table.concat(shufl), count
end

local words = { "abracadabra", "seesaw", "elk", "grrrrrr", "up", "a" }

local function test(r)
  print(r and "RANDOM:" or "DETERMINISTIC:")
  for _, word in ipairs(words) do
    local shufl, count = bestshuffle(word, r)
    print(string.format("%s, %s, (%d)", word, shufl, count))
  end
  print()
end

test(true)
test(false)
