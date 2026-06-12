class CardPuncher
  TABLE = %w[
  \  1 2 3 4 5 6 7 8 9  ` :   # @ ' = "
   & A B C D E F G H I  ◇ \[  . < ( + !
   - J K L M N O P Q R  ◇ \]  $ * ) ; ^
   | j k l m n o p q r  ◇ ◇   ◇ ◇ ◇ ◇ ◇
   0 / S T U V W X Y Z  ◇ \\  , % _ > ?
   { a b c d e f g h i  ◇ ◇   ◇ ◇ ◇ ◇ ◇
   } ~ s t u v w x y z  ◇ ◇   ◇ ◇ ◇ ◇ ◇
  ].map {|s| s[0] }
  TABLE_COLS = 17
  COL_HOLES = [ [] of Int32 ] +
              (1..9).map {|i| [i] } +
              (1..7).map {|i| [8, i] }
  ROW_HOLES = [ [] of Int32 ] +
              [[12], [11], [12, 11], [0], [0, 12], [0, 11]]

  def self.char_pos (ch)
    TABLE.index!(ch).divmod TABLE_COLS
  end

  def self.punch (s)
    chars = s.chars
    raise "Invalid character" unless chars.all? {|ch| ch.in? TABLE }
    raise "Line too long"     unless chars.size <= 80
    card = chars.map {|ch|
      holes = Array.new(13, false)
      row, col = char_pos ch
      (ROW_HOLES[row] + COL_HOLES[col]).each do |h| holes[h] = true end
      holes
    }
    puts   " _" + "_"*80 + "_."
    printf "/ %-80s |\n", s
    ([12, 11] + (0..9).to_a).each do |punch_hole|
      print "| "
      print (1..80).zip?(card).map {|(i, card_col)|
        if card_col && card_col[punch_hole]
          "▮"
        elsif punch_hole < 10
          punch_hole
        else
          " "
        end
      }.join
      puts " |"
    end
    puts "|_" + "_"*80 + "_|"
  end
end

CardPuncher.punch "&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'=\"[.<(+|]$*);^\\,%_>?"
CardPuncher.punch %(puts "Hello World!")
