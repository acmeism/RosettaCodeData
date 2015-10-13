def variable_counter(b)
  int_vars = []
  sum = 0
  check_var = lambda do |name, value|
    if value.is_a?(Integer)
      int_vars << name
      sum += value
    end
  end

  global_variables.each {|varname| check_var.call(varname, eval(varname.to_s))}
  eval('local_variables', b).each {|varname| check_var.call(varname, eval(varname.to_s, b))}

  puts "these #{int_vars.length} variables in the global scope are integers:"
  puts int_vars.inspect
  puts "their sum is: #{sum}"
end

an_int = 5
a_string = 'foo'
a_float = 3.14

variable_counter(binding)
