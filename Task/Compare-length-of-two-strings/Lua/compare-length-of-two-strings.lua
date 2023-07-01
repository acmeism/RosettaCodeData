function test(list)
  table.sort(list, function(a,b) return #a > #b end)
  for _,s in ipairs(list) do print(#s, s) end
end
test{"abcd", "123456789", "abcdef", "1234567"}
