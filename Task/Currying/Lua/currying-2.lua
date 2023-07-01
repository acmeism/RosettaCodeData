local curry do
  local call,env = function(fn,...)return fn(...)end
  local fmt,cat,rawset,rawget,floor = string.format,table.concat,rawset,rawget,math.floor
  local curryHelper = setmetatable({},{
    __call = function(me, n, m, ...)return me[n*256+m](...)end,
    __index = function(me,k)
      local n,m = floor(k / 256), k % 256
      local r,s = {},{} for i=1,m do r[i],s[i]='_'..i,'_'..i end s[1+#s]='...'
      r,s=cat(r,','),cat(s,',')
      s = n<m and fmt('CALL(%s)',r) or fmt('function(...)return ME(%d,%d+select("#",...),%s)end',n,m,s)
      local sc = fmt('local %s=... return %s',r,s)
      rawset(me,k,(loadstring or load)(sc,'_',nil,env) )
      return rawget(me,k)
    end})
  env = {CALL=call,ME=curryHelper,select=select}
  function curry(...)
    local pn,n,fn = select('#',...),...
    if pn==1 then n,fn = debug.getinfo(n, 'u'),n ; n = n and n.nparams end
    if type(n)~='number' or n~=floor(n)then return nil,'invalid curry'
    elseif n<=0 then return fn -- edge case
    else return curryHelper(n,1,fn)
    end
  end
end

-- test
function add(x,y)
   return x+y
end

local adder = curry(add) -- get params count from debug.getinfo
assert(adder(3)(4) == 3+4)
local add2 = adder(2)
assert(add2(3) == 2+3)
assert(add2(5) == 2+5)
