def outer(a,b,c)
  middle a+b, b+c
end

def middle(d,e)
  inner d+e
end

def inner(f)
  raise
  puts "this will not be printed"
end

begin
  outer 2,3,5
rescue Exception => e
  puts e.backtrace
end
puts "continuing after the rescue..."
