class U0 < Exception
end

class U1 < Exception
end

def foo
  2.times do |i|
    begin
      bar(i)
    rescue e : U0
      puts "rescued #{e}"
    end
  end
end

def bar(i : Int32)
    baz(i)
end

def baz(i : Int32)
  raise U0.new("this is u0") if i == 0
    raise U1.new("this is u1") if i == 1
end

foo
