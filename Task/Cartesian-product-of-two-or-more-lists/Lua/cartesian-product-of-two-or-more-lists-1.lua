  local pk,upk = table.pack, table.unpack
  local getn = function(t)return #t end
  local const = function(k)return function(e) return k end end
  local function attachIdx(f)-- one-time-off function modifier
    local idx = 0
    return function(e)idx=idx+1 ; return f(e,idx)end
  end

  local function reduce(t,acc,f)
    for i=1,t.n or #t do acc=f(acc,t[i])end
    return acc
  end
  local function imap(t,f)
    local r = {n=t.n or #t, r=reduce, u=upk, m=imap}
    for i=1,r.n do r[i]=f(t[i])end
    return r
  end

  local function prod(...)
    local ts = pk(...)
    local limit = imap(ts,getn)
    local idx, cnt = imap(limit,const(1)),  0
    local max = reduce(limit,1,function(a,b)return a*b end)
    local function ret(t,i)return t[idx[i]] end
    return function()
      if cnt>=max then return end -- no more output
      if cnt==0 then -- skip for 1st
        cnt = cnt + 1
      else
        cnt, idx[#idx] = cnt + 1, idx[#idx] + 1
        for i=#idx,2,-1 do -- update index list
          if idx[i]<=limit[i] then
            break -- no further update need
          else -- propagate limit overflow
            idx[i],idx[i-1] = 1, idx[i-1]+1
          end
        end
      end
      return cnt,imap(ts,attachIdx(ret)):u()
    end
  end
--- test
  for i,a,b in prod({1,2},{3,4}) do
    print(i,a,b)
  end
  print()
  for i,a,b in prod({3,4},{1,2}) do
    print(i,a,b)
  end
