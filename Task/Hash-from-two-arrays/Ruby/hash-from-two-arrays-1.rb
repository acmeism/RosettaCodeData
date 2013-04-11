keys=['hal',666,[1,2,3]]
vals=['ibm','devil',123]

if RUBY_VERSION >= '1.8.7'
  # Easy way, but needs Ruby 1.8.7 or later.
  hash = Hash[keys.zip(vals)]
else
  hash = keys.zip(vals).inject({}) {|h, kv| h.store(*kv); h }
end

p hash  # => {"hal"=>"ibm", 666=>"devil", [1, 2, 3]=>123}

#retrieve the value linked to the key [1,2,3]
puts hash[ [1,2,3] ]  # => 123
