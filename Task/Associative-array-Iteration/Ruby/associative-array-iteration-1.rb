my_dict = { "hello" => 13,
	   "world" => 31,
	   "!"     => 71 }

# iterating over key-value pairs:
my_dict.each {|key, value| puts "key = #{key}, value = #{value}"}
# or
my_dict.each_pair {|key, value| puts "key = #{key}, value = #{value}"}

# iterating over keys:
my_dict.each_key {|key| puts "key = #{key}"}

# iterating over values:
my_dict.each_value {|value| puts "value =#{value}"}
