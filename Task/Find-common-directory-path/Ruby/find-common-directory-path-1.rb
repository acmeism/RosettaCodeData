require 'abbrev'

dirs = %w( /home/user1/tmp/coverage/test /home/user1/tmp/covert/operator /home/user1/tmp/coven/members )

common_prefix = dirs.abbrev.keys.min_by {|key| key.length}.chop  # => "/home/user1/tmp/cove"
common_directory = common_prefix.sub(%r{/[^/]*$}, '')            # => "/home/user1/tmp"
