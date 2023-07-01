function rot13(s)
  return (s:gsub("%a", function(c) c=c:byte() return string.char(c+(c%32<14 and 13 or -13)) end))
end
