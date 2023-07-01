function findspds(primelist, diffs)
  local results = {}
  for i = 1, #primelist-#diffs do
    result = {primelist[i]}
    for j = 1, #diffs do
      if primelist[i+j] - primelist[i+j-1] == diffs[j] then
        result[j+1] = primelist[i+j]
      else
        result = nil
        break
      end
    end
    results[#results+1] = result
  end
  return results
end

primegen:generate(nil, 1000000)
for _,diffs in ipairs{{2}, {1}, {2,2}, {2,4}, {4,2}, {6,4,2}} do
  spdlist = findspds(primegen.primelist, diffs)
  print("DIFFS: ["..table.concat(diffs," ").."]")
  print("COUNT: "..#spdlist)
  print("FIRST: ["..table.concat(spdlist[1]," ").."]")
  print("LAST : ["..table.concat(spdlist[#spdlist]," ").."]")
  print()
end
