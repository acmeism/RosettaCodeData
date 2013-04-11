def first(main_var, main_binding)
  foo = 42
  second [[main_var, main_binding], ["foo", binding]]
end

def second(args)
  sqr = lambda {|x| x**2}
  deref(args << ["sqr", binding])
end

def deref(stuff)
  stuff.each do |varname, context|
    puts "value of #{varname} is #{eval varname, context}"
  end
end

hello = "world"
first "hello", binding
