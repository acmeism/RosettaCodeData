def make_square
  # it's a square at heart...
  (('A'..'Z').to_a + ('0'..'9').to_a).shuffle!
end

def make_key (size)
  words = File.open("unixdict.txt") do |f|
    f.each_line.select {|w| w.size == size && w.chars.to_set.size == size }.to_a
  end
  raise "no suitable key found" if words.empty?
  words.sample
end

def adfgvx_encrypt (message, square, key)
  h = "ADFGVX".chars
  message.chars.flat_map {|ch|
    row, col = square.index!(ch).divmod(6)
    [ h[row], h[col] ]
  }
    .in_groups_of(key.size)
    .transpose
    .zip(key.chars)
    .sort_by {|_, key| key }
    .map {|col, _| col.join }
    .join(" ")
end

def adfgvx_decrypt (message, square, key)
  h = "ADFGVX".chars
  sorted_key = key.chars.sort!
  cols = message.split.map &.chars
  max_size = cols.max_of &.size
  cols.map {|col| col + [nil]*(max_size-col.size) }
    .zip(sorted_key)
    .sort_by {|_, ch| key.index! ch }
    .map {|col, _| col }
    .transpose
    .flatten.compact
    .in_slices_of(2)
    .map {|(row, col)| square[ h.index!(row)*6 + h.index!(col) ] }
    .join
end

def show (title, message, square, key)
  encrypted = adfgvx_encrypt message, square, key
  decrypted = adfgvx_decrypt encrypted, square, key
  puts title
  puts " - Alphabet: #{square.join}"
  puts " - Key:      #{key}"
  puts " - Message:   #{message}"
  puts " - Encrypted: #{encrypted}"
  puts " - Decrypted: #{decrypted}"
  puts
end

message = "ATTACKAT1200AM"

wiki_square = "NA1C3H8TB2OME5WRPD4F6G7I9J0KLQSUVXYZ".chars
wiki_key = "PRIVACY"

show "Wikipedia example:", message, wiki_square, wiki_key
show "Random square and key:", message, make_square, make_key(9)
