class Array
  # useful method to work on parts of the array in-place
  def slice (start, length)
    start = size - start if start < 0
    raise "Out of bounds" unless start >= 0 && length >= 0 && start + length <= size
    Slice.new(to_unsafe + start, length)
  end
end

def encode (message, symbols)
  symbols = symbols.dup
  message.chars.map {|ch|
    idx = symbols.index! ch
    symbols.slice(0, idx+1).rotate! -1
    idx
  }
end

def decode (message, symbols)
  symbols = symbols.dup
  message.map {|idx|
    ch = symbols[idx]
    symbols.slice(0, idx+1).rotate! -1
    ch
  }.join
end

symbols = ('a'..'z').to_a
["broood", "bananaaa", "hiphophiphop"].each do |word|
  encoded = encode(word, symbols)
  decoded = decode(encoded, symbols)
  printf "%-12s -> %-38s -> %s\n", word, encoded, decoded
end
