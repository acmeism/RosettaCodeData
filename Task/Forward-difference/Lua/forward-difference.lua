function dif(a, b, ...)
  if(b) then return b-a, dif(b, ...) end
end
function dift(t) return {dif(table.unpack(t))} end
print(table.unpack(dift{1,3,6,10,15}))
