sums, taxis, limit = {}, {}, 1200
for i = 1, limit do
  for j = 1, i-1 do
    sum = i^3 + j^3
    sums[sum] = sums[sum] or {}
    table.insert(sums[sum], i.."^3 + "..j.."^3")
  end
end
for k,v in pairs(sums) do
  if #v > 1 then table.insert(taxis, { sum=k, num=#v, terms=table.concat(v," = ") }) end
end
table.sort(taxis, function(a,b) return a.sum<b.sum end)
for i=1,2006 do
  if i<=25 or i>=2000 or taxis[i].num==3 then
    print(string.format("%4d%s: %10d = %s", i, taxis[i].num==3 and "*" or " ", taxis[i].sum, taxis[i].terms))
  end
end
print("* n=3")
