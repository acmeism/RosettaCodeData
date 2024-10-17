foo : Int32 | Nil = 5 # this variable's type can be Int32 or Nil
bar : Int32? = nil    # equivalent type to above, but shorter syntax
baz : Int32 = 5       # this variable can never be nil

foo.not_nil!          # nothing happens, since 5 is not nil
puts "Is foo nil? #{foo.nil?}"
foo = nil
puts "Now is foo nil? #{foo.nil?}"

puts "Does bar equal nil? #{bar == nil}"

puts "Is bar equivalent to nil? #{bar === nil}"

bar.not_nil!          # bar is nil, so an exception is thrown
