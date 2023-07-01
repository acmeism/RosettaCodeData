function sleeprint(n)
  local t0 = os.time()
  while os.time() - t0 <= n do
    coroutine.yield(false)
  end
  print(n)
  return true
end

coroutines = {}
for i=1, #arg do
  wrapped = coroutine.wrap(sleeprint)
  table.insert(coroutines, wrapped)
  wrapped(tonumber(arg[i]))
end

done = false
while not done do
  done = true
  for i=#coroutines,1,-1 do
    if coroutines[i]() then
      table.remove(coroutines, i)
    else
      done = false
    end
  end
end
