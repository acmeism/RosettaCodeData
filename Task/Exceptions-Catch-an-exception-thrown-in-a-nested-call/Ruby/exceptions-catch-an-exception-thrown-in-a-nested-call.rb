def foo
  2.times do |i|
    begin
      bar(i)
    rescue U0
      $stderr.puts "captured exception U0"
    end
  end
end

def bar(i)
  baz(i)
end

def baz(i)
  raise i == 0 ? U0 : U1
end

class U0 < StandardError; end

class U1 < StandardError; end

foo
