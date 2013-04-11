def encode(string)
  encoding = []
  for char, repeat in string.scan(/(.)(\1*)/)
    encoding << [char, 1 + repeat.length]
  end
  encoding
end

def decode(encoding)
  decoding = ""
  for char, length in encoding
    decoding << char * length
  end
  decoding
end
