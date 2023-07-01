mathtype = math.type or type -- polyfill <5.3
function test(xs, ps)
  for _,x in ipairs(xs) do
    for _,p in ipairs(ps) do
      print(string.format("%2.f  %7s  %2.f  %7s    %4.f    %4.f    %4.f    %4.f", x, mathtype(x), p, mathtype(p), -x^p, -(x)^p, (-x)^p, -(x^p)))
    end
  end
end
print(" x  type(x)   p  type(p)    -x^p  -(x)^p  (-x)^p  -(x^p)")
print("--  -------  --  -------  ------  ------  ------  ------")
test( {-5.,5.}, {2.,3.} ) -- "float" (or "number" if <5.3)
if math.type then -- if >=5.3
  test( {-5,5}, {2,3} ) -- "integer"
end
