separator = '/'
paths = dirs.collect {|dir| dir.split(separator)}
uncommon_idx = paths[0].zip(*paths[1..-1]).index {|dirnames| dirnames.uniq.length > 1}
uncommon_idx = paths[0].length  unless uncommon_idx               # if uncommon_idx==nil
common_directory = paths[0][0...uncommon_idx].join(separator)     # => "/home/user1/tmp"
