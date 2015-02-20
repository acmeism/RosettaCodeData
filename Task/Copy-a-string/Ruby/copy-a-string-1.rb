original = "hello"
reference = original          # copies reference
copy1 = original.dup          # instance of original.class
copy2 = String.new(original)  # instance of String

original << " world!"         # append
p reference                   #=> "hello world!"
p copy1                       #=> "hello"
p copy2                       #=> "hello"
