function findcps(primelist, fcmp)
  local currlist = {primelist[1]}
  local longlist, prevdiff = currlist, 0
  for i = 2, #primelist do
    local diff = primelist[i] - primelist[i-1]
    if fcmp(diff, prevdiff) then
      currlist[#currlist+1] = primelist[i]
      if #currlist > #longlist then
        longlist = currlist
      end
    else
      currlist = {primelist[i-1], primelist[i]}
    end
    prevdiff = diff
  end
  return longlist
end

primegen:generate(nil, 1000000)
cplist = findcps(primegen.primelist, function(a,b) return a>b end)
print("ASC  ("..#cplist.."):  ["..table.concat(cplist, " ").."]")
cplist = findcps(primegen.primelist, function(a,b) return a<b end)
print("DESC ("..#cplist.."):  ["..table.concat(cplist, " ").."]")
