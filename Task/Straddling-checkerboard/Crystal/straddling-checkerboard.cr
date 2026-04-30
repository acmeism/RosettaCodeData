def encrypt (board, message)
  prefixes = [""] + board.first.chars.each.with_index.select {|ch, _| ch == ' ' }.map(&.last.to_s).to_a
  encode_letter = ->(ch : Char) {
    col = nil
    row = board.index {|r| col = r.index ch}
    raise "incomplete board" unless col && row
    prefixes[row] + col.to_s
  }
  String.build do |s|
    message.each_char do |ch|
      if ch.ascii_number?
        s << encode_letter['/'] << ch
      else
        ch = ch.ascii_letter? ? ch.upcase : '.'
        s << encode_letter[ch]
      end
    end
  end
end

def decrypt (board, message)
  prefixes = board.first.chars.each.with_index.select {|ch, _| ch == ' ' }.map {|ch, idx| '0' + idx}.to_a
  message = message.chars
  String.build do |s|
    i = 0
    while i < message.size
      row = prefixes.index(message[i])
      letter = if row
                 board[row+1][message[i+=1].to_i]
               else
                 board[0][message[i].to_i]
               end
      if letter == '/'
        s << message[i+=1]
      else
        s << letter
      end
      i += 1
    end
  end
end

board = ["ET AON RIS", "BCDFGHJKLM", "PQ/UVWXYZ."]

original = "One night-it was on the twentieth of March, 1888-I was returning"
coded = encrypt(board, original)
decoded = decrypt(board, coded)

p! original, coded, decoded
