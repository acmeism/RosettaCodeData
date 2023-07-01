require "lpeg"
local P, C, Cf, Cc = lpeg.P, lpeg.C, lpeg.Cf, lpeg.Cc
lookandsay = Cf(Cc"" * C(P"1"^1 + P"2"^1 + P"3"^1)^1, function (a, b) return a .. #b .. string.sub(b,1,1) end)
t = "1"
for i = 1, 10 do
  print(t)
  t = lookandsay:match(t)
end
