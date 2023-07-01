function get(key)
  return (function(arg) return arg[key] end)
end

function is_pythagorean(arg)
  return (arg.x^2 + arg.y^2 == arg.z^2)
end

function list_pythagorean_triples(n)
  return LC:new():range("x",1,n):range("y",1,get("x")):range("z", get("y"), n):where(is_pythagorean).iter
end

for arg in list_pythagorean_triples(100) do
  print(arg.x, arg.y, arg.z)
end
