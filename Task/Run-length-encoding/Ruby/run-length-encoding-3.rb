def encode(string)
  string.scan(/(.)(\1*)/).inject("") do |encoding, (char, repeat)|
    encoding << (1 + repeat.length).to_s << char
  end
end

def decode(string)
  string.scan(/(\d+)(\D)/).inject("") do |decoding, (length, char)|
    decoding << char * length.to_i
  end
end
