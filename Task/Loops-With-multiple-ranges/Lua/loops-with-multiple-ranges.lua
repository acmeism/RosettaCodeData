-- support:
function T(t) return setmetatable(t, {__index=table}) end
table.range = function(t,a,b,c) local s=T{} for i=a,b,c or 1 do s[#s+1]=i end return s end
table.clone = function(t) local s=T{} for k,v in ipairs(t) do s[k]=v end return s end
table.chain = function(t,u) local s=t:clone() for i=1,#u do s[#s+1]=u[i] end return s end
unpack = unpack or table.unpack -- polyfill 5.2 vs 5.3

-- impl:
-- Multi-Range-Loop
-- param: table of tables of range specs
-- return: iterator over the chain of all ranges
function mrl(tt)
  local s=T{}
  for _,t in ipairs(tt) do s=s:chain(T{}:range(unpack(t))) end
  return ipairs(s)
end

-- demo:
prod,sum,x,y,z,one,three,seven = 1,0,5,-5,-2,1,3,7
for _,j in mrl{
  { -three,    3^3,  three },
  { -seven,  seven,      x },
  {    555,  550-y         },
  {     22,    -28, -three },
  {   1927,   1939         },
  {      x,      y,      z },
  {   11^x, 11^x+1         }} do
  sum = sum + math.abs(j)
  if math.abs(prod) < 2^27 and j~=0 then prod = prod * j end
end
print(" sum= " .. sum)
print("prod= " .. prod)
