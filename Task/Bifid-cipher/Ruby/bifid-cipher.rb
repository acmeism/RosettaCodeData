def cleanMsg(msg, square)
  msg.upcase!
  msg.delete!(' ')
  msg.delete!('J') if square.index('J') == nil
end

def encrypt(msg, square)
  cleanMsg msg, square
  sq_size = (square.length ** 0.5).to_i
  rows = [0] * msg.length
  cols = [0] * msg.length
  (0...msg.length).each do |i|
    p = square.index(msg[i])
    rows[i], cols[i] = p / sq_size, p % sq_size
  end
  result = ""
  rows.concat(cols).each_slice(2) do |coord|
    result += square[coord[0]*sq_size + coord[1]]
  end
  return result
end

def decrypt(msg, square)
  msg.upcase!; square.upcase!
  sq_size = (square.length ** 0.5).to_i
  coords = []
  result = ""
  (0...msg.length).each do |i|
    p = square.index(msg[i])
    coords << p / sq_size
    coords << p % sq_size
  end
  for i in (0...coords.length/2) do
    row, col = coords[i], coords[i+coords.length/2]
    result += square[row*sq_size + col]
  end
  return result
end

def printSquare(square)
  sq_size = (square.length ** 0.5).to_i
  (0..square.length).step(sq_size).each do |i|
    print square[i...(i+sq_size)], "\n"
  end
end

tests = [["ATTACKATDAWN" , "ABCDEFGHIKLMNOPQRSTUVWXYZ"],
         ["FLEEATONCE"   , "BGWKZQPNDSIOAXEFCLUMTHYVR"],
         ["ATTACKATDAWN" , "ABCDEFGHIKLMNOPQRSTUVWXYZ"],
         ["the invasion will start on the first of january", "BGWKZQPNDSIOAXEFCLUMTHYVR"],
         ["THIS MESSAGE HAS NUMBERS 2023", "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"],
]

for test in tests
  message = test[0]; square = test[1];
  encrypted = encrypt(message, square)
  decrypted = decrypt(encrypted, square)

  puts "using the polybius:"
  printSquare(square)
  puts "the plain message:", message
  puts "encrypted:", encrypted
  puts "decrypted:", decrypted
  puts "===================================================="
end
