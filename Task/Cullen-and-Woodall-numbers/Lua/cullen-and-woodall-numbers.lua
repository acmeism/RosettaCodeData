function T(t) return setmetatable(t, {__index=table}) end
table.range = function(t,n) local s=T{} for i=1,n do s[i]=i end return s end
table.map = function(t,f) local s=T{} for i=1,#t do s[i]=f(t[i]) end return s end

function cullen(n) return (n<<n)+1 end
print("First 20 Cullen numbers:")
print(T{}:range(20):map(cullen):concat(" "))

function woodall(n) return (n<<n)-1 end
print("First 20 Woodall numbers:")
print(T{}:range(20):map(woodall):concat(" "))
