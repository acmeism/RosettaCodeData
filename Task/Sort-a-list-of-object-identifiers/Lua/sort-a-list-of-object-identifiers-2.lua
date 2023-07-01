local function oidGen(s)
  local wrap, yield = coroutine.wrap, coroutine.yield
  return wrap(function()
    for n in s:gmatch"%d+"do yield(tonumber(n))end
  end)
end

local function oidCmp(a,b)
  local agen,bgen = oidGen(a),oidGen(b)
  local n,m = agen(),bgen()
  while n and m do
    if n~=m then return n<m end
    n,m = agen(),bgen()
  end
  return m and true or false -- bgen longer with previous equal
end

local OIDs = {
    "1.3.6.1.4.1.11.2.17.19.3.4.0.10",
    "1.3.6.1.4.1.11.2.17.5.2.0.79",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
    "1.3.6.1.4.1.11150.3.4.0.1",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
    "1.3.6.1.4.1.11150.3.4.0"
}

table.sort(OIDs, oidCmp)
for _, oid in pairs(OIDs) do print(oid) end
