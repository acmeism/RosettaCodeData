function isHarshad(n)
    local s=0
    local n_str=tostring(n)
    for i=1,#n_str do
        s=s+tonumber(n_str:sub(i,i))
    end
    return n%s==0
end

local count=0
local harshads={}
local n=1

while count<20 do
    if isHarshad(n) then
        count=count+1
        table.insert(harshads, n)
    end
    n=n+1
end

print(table.concat(harshads, " "))

local h=1001
while not isHarshad(h) do
    h=h+1
end
print(h)
