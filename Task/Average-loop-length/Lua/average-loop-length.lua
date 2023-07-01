function average(n, reps)
  local count = 0
  for r = 1, reps do
    local f = {}
    for i = 1, n do f[i] = math.random(n) end
    local seen, x = {}, 1
    while not seen[x] do
      seen[x], x, count = true, f[x], count+1
    end
  end
  return count / reps
end

function analytical(n)
  local s, t = 1, 1
  for i = n-1, 1, -1 do t=t*i/n s=s+t end
  return s
end

print(" N    average    analytical    (error)")
print("===  =========  ============  =========")
for n = 1, 20 do
  local avg, ana = average(n, 1e6), analytical(n)
  local err = (avg-ana) / ana * 100
  print(string.format("%3d  %9.4f  %12.4f  (%6.3f%%)", n, avg, ana, err))
end
