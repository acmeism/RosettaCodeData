local wrap, yield = coroutine.wrap, coroutine.yield
local function perm(n)
    local r = {}
    for i=1,n do r[i]=i end
  return wrap(function()
    local function swap(m)
      if m==0 then
        yield(r)
      else
        for i=m,1,-1 do
          r[i],r[m]=r[m],r[i]
          swap(m-1)
          r[i],r[m]=r[m],r[i]
        end
      end
    end
    swap(n)
  end)
end

local function iden(...)return ... end
local function imap(t,f)
  local r,fn = {m=imap, c=table.concat, u=table.unpack}, f or iden
  for i=1,#t do r[i]=fn(t[i])end
  return r
end

local tenants = {'Baker', 'Cooper', 'Fletcher', 'Miller', 'Smith'}

local conds = {
  'Baker  ~= TOP',
  'Cooper ~= BOTTOM',
  'Fletcher ~= TOP and Fletcher~= BOTTOM',
  'Miller > Cooper',
  'Smith + 1 ~= Fletcher and Smith - 1 ~= Fletcher',
  'Cooper + 1 ~= Fletcher and Cooper - 1 ~= Fletcher',
}

local function makePredicate(conds, tenants)
  return load('return function('..imap(tenants):c','..
    ') return ' ..
    imap(conds,function(c)
      return string.format("(%s)",c)
    end):c"and "..
    " end ",'-',nil,{TOP=5, BOTTOM=1})()
end

local function solve (conds, tenants)
  local try, pred, upk = perm(#tenants), makePredicate(conds, tenants), table.unpack
  local answer = try()
  while answer and not pred(upk(answer)) do answer = try()end
  if answer then
    local floor = 0
    return imap(answer, function(person)
        floor=floor+1;
        return string.format(" %s lives on floor %d",tenants[floor],person)
    end):c"\n"
  else
    return nil, 'no solution'
  end
end

print(solve (conds, tenants))
