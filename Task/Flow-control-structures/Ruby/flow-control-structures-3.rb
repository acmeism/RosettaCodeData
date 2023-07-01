def some_method
  # ...
  if some_condition
    throw :get_me_out_of_here
  end
  # ...
end

catch :get_me_out_of_here do
  for ...
    for ...
      some_method
    end
  end
end

puts "continuing after catching the throw"
