-- support
function T(t) return setmetatable(t, {__index=table}) end
table.eql = function(t,u) if #t~=#u then return false end for i=1,#t do if t[i]~=u[i] then return false end end return true end
table.rol = function(t,n) local s=T{} for i=1,#t do s[i]=t[(i+n-1)%#t+1] end return s end
table.rev = function(t) local s=T{} for i=1,#t do s[#t-i+1]=t[i] end return s end

-- 1
function pfeq(pf1, pf2)
  if #pf1 ~= #pf2 then return false end -- easy case
  for w = 0,1 do -- exhaustive cases
    local pfw = pf1 -- w:winding
    if w==1 then pfw=pfw:rev() end
    for r = 0,#pfw do
      local pfr = pfw -- r:rotate
      if r>0 then pfr=pfr:rol(r) end
      if pf2:eql(pfr) then return true end
    end
  end
  return false
end

Q = T{8, 1, 3}
R = T{1, 3, 8}
U = T{18, 8, 14, 10, 12, 17, 19}
V = T{8, 14, 10, 12, 17, 19, 18}
print("pfeq(Q,R): ", pfeq(Q, R))
print("pfeq(U,V): ", pfeq(U, V))

-- 2
function ef2pf(ef)
  local pf, hse = T{}, T{} -- hse:hash of sorted edges
  for i,e in ipairs(ef) do table.sort(e) hse[e]=e end
  local function nexte(e)
    if not e then return ef[1] end
    for k,v in pairs(hse) do
      if e[2]==v[1] then return v end
      if e[2]==v[2] then v[1],v[2]=v[2],v[1] return v end
    end
  end
  local e = nexte()
  while e do
    pf[#pf+1] = e[1]
    hse[e] = nil
    e = nexte(e)
  end
  if #pf ~= #ef then pf=T{"failed to convert edge format to perimeter format"} end
  return pf
end

E = {{1, 11}, {7, 11}, {1, 7}}
F = {{11, 23}, {1, 17}, {17, 23}, {1, 11}}
G = {{8, 14}, {17, 19}, {10, 12}, {10, 14}, {12, 17}, {8, 18}, {18, 19}}
H = {{1, 3}, {9, 11}, {3, 11}, {1, 11}}
print("ef2pf(E): ", ef2pf(E):concat(","))
print("ef2pf(F): ", ef2pf(F):concat(","))
print("ef2pf(G): ", ef2pf(G):concat(","))
print("ef2pf(H): ", ef2pf(H):concat(","))
