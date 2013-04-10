hash=Hash.new{|h,k|h[k]="key #{k} was added at #{Time.now}"}
hash[777]  # => 'key 777 was added at Sun Apr 03 13:49:57 -0700 2011'
hash[555]  # => 'key 555 was added at Sun Apr 03 13:50:01 -0700 2011'
hash[777]  # => 'key 777 was added at Sun Apr 03 13:49:57 -0700 2011'
