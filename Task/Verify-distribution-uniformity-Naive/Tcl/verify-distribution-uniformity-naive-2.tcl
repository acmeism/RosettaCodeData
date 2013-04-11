# First, a uniformly distributed random variable
puts [distcheck {expr {int(10*rand())}} 100000]

# Now, one that definitely isn't!
puts [distcheck {expr {rand()>0.95}} 100000]
