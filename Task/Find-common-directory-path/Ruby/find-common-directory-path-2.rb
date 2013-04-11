separator = '/'
paths = dirs.collect {|dir| dir.split(separator)}
uncommon_idx = paths.transpose.each_with_index.find {|dirnames, idx| dirnames.uniq.length > 1}.last
common_directory = paths[0][0 ... uncommon_idx].join(separator)  # => "/home/user1/tmp"
