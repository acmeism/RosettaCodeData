def foo
  begin
    bar
  rescue U0
    puts "captured exception U0"
  end
end

def bar
  baz
end

def baz
  raise $bazcount == 1 ? U0 : U1
end

class U0 < Exception
end

class U1 < Exception
end

for $bazcount in [1, 2]
  foo
end
