t = {}
print(t)
f = function() end
print(f)
c = coroutine.create(function() end)
print(c)
u = io.open("/dev/null","w")
print(u)
print(_G, _ENV) -- global/local environments (are same here)
print(string.format("%p %p %p", print, string, string.format)) -- themselves formatted as pointers
