def encode(string)
  string.scan(/(.)(\1*)/).collect do |char, repeat|
    [1 + repeat.length, char]
  end.join
end

def decode(string)
  string.scan(/(\d+)(\D)/).collect {|length, char| char * length.to_i}.join
end
