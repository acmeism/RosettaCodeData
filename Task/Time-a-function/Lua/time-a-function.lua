function bench(Function, ...)
 local t = os.time()
 local clock1 = os.clock()
 Function(...)
 local c = os.clock()-clock
 return os.time()-t, c
end

function sleep(n)
 local start = os.time()
 repeat until os.time()-start==n
end

print( bench(sleep, 2) )
