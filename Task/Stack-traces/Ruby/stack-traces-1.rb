def outer(a,b,c)
  middle a+b, b+c
end

def middle(d,e)
  inner d+e
end

def inner(f)
  puts caller(0)
  puts "continuing... my arg is #{f}"
end

outer 2,3,5
