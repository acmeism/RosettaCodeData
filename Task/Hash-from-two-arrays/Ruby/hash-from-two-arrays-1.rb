keys = ['hal',666,[1,2,3]]
vals = ['ibm','devil',123]

hash = Hash[keys.zip(vals)]

p hash  # => {"hal"=>"ibm", 666=>"devil", [1, 2, 3]=>123}

#retrieve the value linked to the key [1,2,3]
puts hash[ [1,2,3] ]  # => 123
