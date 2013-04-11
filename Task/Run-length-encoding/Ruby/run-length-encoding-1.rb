def encode(string)
  string.scan(/(.)(\1*)/).collect do |char, repeat|
    [char, 1 + repeat.length]
  end
end

def decode(encoding)
  encoding.collect { |char, length| char * length }.join
end

orig = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
enc = encode(orig)    # => [["W", 12], ["B", 1], ["W", 12], ["B", 3], ["W", 24], ["B", 1], ["W", 14]]
dec = decode(enc)
puts "success!" if dec == orig
