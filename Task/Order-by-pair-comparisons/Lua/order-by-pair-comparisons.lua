colors = { "violet", "red", "green", "indigo", "blue", "yellow", "orange" }
print("unsorted:  " .. table.concat(colors," "))
known, notyn, nc, nq = {}, {n="y",y="n"}, 0, 0
table.sort(colors, function(a,b)
  nc = nc + 1
  if not known[a] then known[a]={[a]="n"} end
  if not known[b] then known[b]={[b]="n"} end
  if not (known[a][b] or known[b][a]) then
    io.write("Is '" .. a .. "' < '" .. b .."'?  (y/n):  ")
    nq, known[a][b] = nq+1, io.read()
    if a~=b then known[b][a] = notyn[known[a][b]] end
  end
  return known[a][b]=="y"
end)
print("sorted:  " .. table.concat(colors," "))
print("(" .. nq .. " questions needed to resolve " .. nc .. " comparisons)")
