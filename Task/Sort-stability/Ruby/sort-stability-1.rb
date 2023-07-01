ary = [["UK", "London"],
       ["US", "New York"],
       ["US", "Birmingham"],
       ["UK", "Birmingham"]]
p ary.sort {|a,b| a[1] <=> b[1]}
# MRI reverses the Birminghams:
# => [["UK", "Birmingham"], ["US", "Birmingham"], ["UK", "London"], ["US", "New York"]]
