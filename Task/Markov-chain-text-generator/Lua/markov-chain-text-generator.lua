local function pick(t)
  local i = math.ceil(math.random() * #t)
  return t[i]
end

local n_prevs = tonumber(arg[1]) or 2
local n_words = tonumber(arg[2]) or 8

local dict, wordset = {}, {}
local prevs, pidx = {}, 1

local function add(word)   -- add new word to dictionary
  local prev = ''
  local i, len = pidx, #prevs

  for _ = 1, len do
    i = i - 1
    if i == 0 then i = len end

    if prev ~= '' then prev = ' ' .. prev end
    prev = prevs[i] .. prev
    local t = dict[prev]
    if not t then
      t = {}
      dict[prev] = t
    end
    t[#t+1] = word
  end
end

for line in io.lines() do
  for word in line:gmatch("%S+") do
    wordset[word] = true
    add(word)
    prevs[pidx] = word
    pidx = pidx + 1; if pidx > n_prevs then pidx = 1 end
  end
end
add('')

local wordlist = {}
for word in pairs(wordset) do
  wordlist[#wordlist+1] = word
end
wordset = nil

math.randomseed(os.time())
math.randomseed(os.time() * math.random())
local word = pick(wordlist)
local prevs, cnt = '', 0

--[[  print the dictionary
for prevs, nexts in pairs(dict) do
  io.write(prevs, ': ')
  for _,word in ipairs(nexts) do
    io.write(word, ' ')
  end
  io.write('\n')
end
]]

for i = 1, n_words do
  io.write(word, ' ')

  if cnt < n_prevs then
    cnt = cnt + 1
  else
    local i = prevs:find(' ')
    if i then prevs = prevs:sub(i+1) end
  end
  if prevs ~= '' then prevs = prevs .. ' ' end
  prevs = prevs .. word

  local cprevs = ' ' .. prevs
  local nxt_words
  repeat
    local i = cprevs:find(' ')
    if not i then break end
    cprevs = cprevs:sub(i+1)
    if DBG then io.write('\x1b[2m', cprevs, '\x1b[m ') end
    nxt_words = dict[cprevs]
  until nxt_words

  if not nxt_words then break end
  word = pick(nxt_words)
end
io.write('\n')
