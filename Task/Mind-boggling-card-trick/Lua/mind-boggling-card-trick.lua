-- support:
function T(t) return setmetatable(t, {__index=table}) end
table.range = function(t,n) local s=T{} for i=1,n do s[i]=i end return s end
table.map = function(t,f) local s=T{} for i=1,#t do s[i]=f(t[i]) end return s end
table.filter = function(t,f) local s=T{} for i=1,#t do if f(t[i]) then s[#s+1]=t[i] end end return s end
table.clone = function(t) local s=T{} for k,v in ipairs(t) do s[k]=v end return s end
table.head = function(t,n) local s=T{} n=n>#t and #t or n for i = 1,n do s[i]=t[i] end return s end
table.tail = function(t,n) local s=T{} n=n>#t and #t or n for i = 1,n do s[i]=t[#t-n+i] end return s end
table.append = function(t,v) local s=t:clone() for i=1,#v do s[#s+1]=v[i] end return s end
table.shuffle = function(t) for i=#t,2,-1 do local j=math.random(i) t[i],t[j]=t[j],t[i] end return t end -- inplace!

-- task:
function cardtrick()
  -- 1.
  local deck = T{}:range(52):map(function(v) return v%2==0 and "B" or "R" end):shuffle()
  print("1. DECK      : " .. deck:concat())
  -- 2. (which guarantees the outcome)
  local bpile, rpile, discs = T{}, T{}, T{}
  local xpile = {B=bpile, R=rpile}
  while #deck>0 do
    local card, next = deck:remove(), deck:remove()
    xpile[card]:insert(next)
    discs:insert(card)
  end
  print("2. BLACK PILE: " .. bpile:concat())
  print("2. RED PILE  : " .. rpile:concat())
  print("2. DISCARDS  : " .. discs:concat())
  -- 3. (which cannot change the outcome)
  local x = math.random(0, math.min(#bpile, #rpile))
  local btake, rtake = T{}, T{}
  for i = 1, x do
    btake:insert((bpile:remove(math.random(#bpile))))
    rtake:insert((rpile:remove(math.random(#rpile))))
  end
  print("3. SWAPPING X: " .. x)
  print("3. BLACK SWAP: keep:" .. bpile:concat() .. "  take:" .. btake:concat())
  print("3. RED SWAP  : keep:" .. rpile:concat() .. "  take:" .. rtake:concat())
  bpile, rpile = bpile:append(rtake), rpile:append(btake)
  print("3. BLACK PILE: " .. bpile:concat())
  print("3. RED PILE  : " .. rpile:concat())
  -- 4. ("proving" that which was guaranteed earlier)
  local binb, rinr = bpile:filter(function(v) return v=="B" end), rpile:filter(function(v) return v=="R" end)
  print("4. BLACK PILE: contains " .. #binb .. " B's")
  print("4. RED PILE  : contains " .. #rinr .. " R's")
  print(#binb==#rinr and "VERIFIED" or "NOT VERIFIED")
  print()
end

-- demo:
math.randomseed(os.time())
for i = 1,3 do cardtrick() end
