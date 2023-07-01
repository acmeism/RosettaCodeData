# Read entire binary file.
str = File.open(path, "rb") {|f| f.read}
