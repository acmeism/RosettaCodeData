enum BifidOp
  Encode
  Decode
end

def bifid_encode (message, alphabet, op : BifidOp = :encode)
  square = alphabet.chars
  side = Math.isqrt(square.size)
  raise "alphabet not a square" unless side*side == square.size
  chars = message.chars
  raise "incomplete alphabet" unless chars.all?(&.in? square)

  coords = chars.flat_map {|ch| [*square.index!(ch).divmod(side)] }

  coords = if op.encode?
             (0...coords.size).step(2).map {|i| coords[i] }.to_a +
               (1...coords.size).step(2).map {|i| coords[i] }.to_a
           else
             half = coords.size//2
             coords[...half].zip(coords[half..]).map {|c1, c2|
               [c1, c2]
             }.flatten
           end
  coords.each_slice(2).map {|(row, col)|
    square[row * side + col]
  }.join
end

poly1 = "ABCDEFGHIKLMNOPQRSTUVWXYZ"
poly2 = "BGWKZQPNDSIOAXEFCLUMTHYVR"
superpoly = (' '..'~').join + "¡éßñø"

attack   = "ATTACKATDAWN"
flee     = "FLEEATONCE"
invasion = "The invasion will start on the first of January".upcase.tr("J", "I").delete("^A-Z")
ataque   = "¡Attack on 1/1 at 23:59, señor!"

[{attack, poly1}, {flee, poly2}, {attack, poly2},
 {invasion, poly1}, {ataque, superpoly}].each do |message, alphabet|
  encoded = bifid_encode(message, alphabet)
  decoded = bifid_encode(encoded, alphabet, :decode)
  puts "Message: #{message} #{alphabet.size > 80 ? "\n" : " "}- Alphabet: #{alphabet}"
  puts "Encoded: #{encoded}"
  puts "Decoded: #{decoded}"
  puts
end
