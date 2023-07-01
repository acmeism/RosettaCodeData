t = Time.now

# textual
puts t        # => 2013-12-27 18:00:23 +0900

# epoch time
puts t.to_i   # => 1388134823

# epoch time with fractional seconds
puts t.to_f   # => 1388134823.9801579

# epoch time as a rational (more precision):
puts Time.now.to_r  # 1424900671883862959/1000000000
