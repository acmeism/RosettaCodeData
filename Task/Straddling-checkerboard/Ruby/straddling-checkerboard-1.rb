class StraddlingCheckerboard
  EncodableChars = "A-Z0-9."
  SortedChars = "  ./" + [*"A".."Z"].join

  def initialize(board = nil)
    if board.nil?
      # create a new random board
      rest = "BCDFGHJKLMPQUVWXYZ/.".chars.shuffle
      @board = ["  ESTONIAR".chars.shuffle, rest[0..9], rest[10..19]]
    elsif board.chars.sort.join == SortedChars
      @board = board.chars.each_slice(10).to_a
    else
      raise ArgumentError, "invalid #{self.class}: #{board}"
    end
    # find the indices of the first row blanks
    @row_labels = @board[0].each_with_index.select {|v, i| v == " "}.map {|v,i| i}

    @mapping = {}
    @board[0].each_with_index {|char, idx| @mapping[char] = idx.to_s unless char == " "}
    @board[1..2].each_with_index do |row, row_idx|
      row.each_with_index do |char, idx|
        @mapping[char] = "%d%d" % [@row_labels[row_idx], idx]
      end
    end
  end

  def encode(message)
    msg = message.upcase.delete("^#{EncodableChars}")
    msg.chars.inject("") do |crypt, char|
      crypt << (char =~ /[0-9]/ ? @mapping["/"] + char : @mapping[char])
    end
  end

  def decode(code)
    msg = ""
    tokens = code.chars
    until tokens.empty?
      token = tokens.shift
      itoken = token.to_i
      unless @row_labels.include?(itoken)
        msg << @board[0][itoken]
      else
        token2 = tokens.shift
        if @mapping["/"] == token + token2
          msg << tokens.shift
        else
          msg << @board[1+@row_labels.index(itoken)][token2.to_i]
        end
      end
    end
    msg
  end

  def to_s
    @board.inject("") {|res, row| res << row.join}
  end

  def inspect
    "#<%s board=%p, row_labels=%p, mapping=%p>" % [self.class, to_s, @row_labels, @mapping]
  end
end
