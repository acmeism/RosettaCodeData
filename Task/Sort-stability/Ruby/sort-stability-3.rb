ary = [["UK", "London"],
       ["US", "New York"],
       ["US", "Birmingham"],
       ["UK", "Birmingham"]]
p ary.stable_sort {|a, b| a[1] <=> b[1]}
# => [["US", "Birmingham"], ["UK", "Birmingham"], ["UK", "London"], ["US", "New York"]]
p ary.stable_sort_by {|x| x[1]}
# => [["US", "Birmingham"], ["UK", "Birmingham"], ["UK", "London"], ["US", "New York"]]
