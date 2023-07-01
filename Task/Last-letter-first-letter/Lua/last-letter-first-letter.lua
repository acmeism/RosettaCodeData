-- BUILDING:
pokemon = [[
audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask]]
words, inits, succs = {}, {}, {}
for word in pokemon:gmatch("%S+") do
  table.insert(words, word)
  local ch = word:sub(1,1)
  inits[ch] = inits[ch] or {}
  table.insert(inits[ch], word)
end
for _,word in pairs(words) do
  succs[word] = {}
  local ch = word:sub(-1,-1)
  if inits[ch] then
    for _,succ in pairs(inits[ch]) do
      if succ~=word then
        table.insert(succs[word],succ)
      end
    end
  end
end

-- SEARCHING:
function expand(list, used, answer)
  local word = list[#list]
  for _,succ in ipairs(succs[word]) do
    if not used[succ] then
      used[succ] = true
      list[#list+1] = succ
      if #list == answer.len then
        local perm = table.concat(list," ")
        answer.perms[perm] = perm
        answer.num = answer.num + 1
      elseif #list > answer.len then
        answer.len = #list
        local perm = table.concat(list," ")
        answer.perms = {[perm] = perm}
        answer.num = 1
      end
      expand(list, used, answer)
      list[#list] = nil
      used[succ] = nil
    end
  end
end
answers = {}
for _,word in ipairs(words) do
  local answer = { word=word, len=0, num=0, perms={} }
  answers[#answers+1] = answer
  expand({word}, {[word]=true}, answer)
end

-- REPORTING:
table.sort(answers, function(a,b) return a.len<b.len or (a.len==b.len and a.word<b.word) end)
print("first word   length   count   example")
print("----------   ------   -----   -------...")
for _,answer in pairs(answers) do
  local perm = next(answer.perms) or ""
  print(string.format("%10s   %6d   %5d   %s", answer.word, answer.len, answer.num, perm))
end
