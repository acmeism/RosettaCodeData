separator = '/'
path0, *paths = dirs.collect {|dir| dir.split(separator)}
uncommon_idx = path0.zip(*paths).index {|dirnames| dirnames.uniq.length > 1}
uncommon_idx = path0.length  unless uncommon_idx                # if uncommon_idx==nil
common_directory = path0[0...uncommon_idx].join(separator)      # => "/home/user1/tmp"
