examples = [
     [ -2,    2,    1],
     [ -2,    2,    0],
     [ -2,    2,   -1],
     [ -2,    2,   10],
     [  2,   -2,    1],
     [  2,    2,    1],
     [  2,    2,   -1],
     [  2,    2,    0],
     [  0,    0,    0]
     ]

examples.each do |start, stop, step|
  as = (start..stop).step(step)
  puts "#{as.inspect} size: #{as.size}"
end
