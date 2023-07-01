procs = Array.new(10){|i| ->{i*i} } # -> creates a lambda
p procs[7].call # => 49
