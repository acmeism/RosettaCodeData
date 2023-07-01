f = File.open("test.txt")
p f.isatty          # => false
p STDOUT.isatty     # => true
