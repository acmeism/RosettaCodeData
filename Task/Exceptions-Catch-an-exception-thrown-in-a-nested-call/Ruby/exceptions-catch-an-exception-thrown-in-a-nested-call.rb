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
  @bazcount = @bazcount.to_i + 1
  raise @bazcount == 1 ? U0 : U1
end

class U0 < StandardError
end

class U1 < StandardError
end

foo
foo
