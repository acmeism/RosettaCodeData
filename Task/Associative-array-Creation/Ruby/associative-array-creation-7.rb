hash = Hash.new { |h, k| "unknown key #{k}" }
hash[666] = 'devil'
hash[777]  # => 'unknown key 777'
hash[666]  # => 'devil'
