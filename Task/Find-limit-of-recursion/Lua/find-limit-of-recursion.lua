local c = 0
function Tail(proper)
  c = c + 1
  if proper then
    if c < 9999999 then return Tail(proper) else return c end
  else
    return 1/c+Tail(proper) -- make the recursive call must keep previous stack
  end
end

local ok,check = pcall(Tail,true)
print(c, ok, check)
c=0
ok,check = pcall(Tail,false)
print(c, ok, check)
