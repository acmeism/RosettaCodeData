unpack = unpack or table.unpack -- <=5.2 vs >=5.3 polyfill

function nexthighestint(n)
  local digits, index = {}, {[0]={},{},{},{},{},{},{},{},{},{}}
  for d in tostring(n):gmatch("%d") do digits[#digits+1]=tonumber(d) end
  for i,d in ipairs(digits) do index[d][#index[d]+1]=i end
  local function findswap(i,d)
    for D=d+1,9 do
      for I=1,#index[D] do
        if index[D][I] > i then return index[D][I] end
      end
    end
  end
  for i = #digits-1,1,-1 do
    local j = findswap(i,digits[i])
    if j then
      digits[i],digits[j] = digits[j],digits[i]
      local sorted = {unpack(digits,i+1)}
      table.sort(sorted)
      for k=1,#sorted do digits[i+k]=sorted[k] end
      return table.concat(digits)
    end
  end
end

tests = { 0, 9, 12, 21, 12453, 738440, 45072010, 95322020, -- task
  "9589776899767587796600", -- stretch
  "123456789098765432109876543210", -- stretchier
  "1234567890999888777666555444333222111000" -- stretchiest
}
for _,n in ipairs(tests) do
  print(n .. " -> " .. (nexthighestint(n) or "(none)"))
end
