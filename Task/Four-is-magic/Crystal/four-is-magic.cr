struct Int
  THOU_PREFIXES = %w(undec dec non oct sept sext quint quadr tr b m)
                  .map(&.+("illion")) + ["thousand", ""]
  TENS = ["", ""] + %w(twen thir for fif six seven eigh nine).map &.+("ty")
  ONES = [""] + %w(one two three four five six seven eight nine ten) +
         %w(eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
  def to_words
    raise "Number to big to express in words" unless self.abs <= Int128::MAX
    return "zero" if self == 0
    String.build do |s|
      n = self
      if n < 0
        s << "negative "
        n = n.abs
      end
      ths = Array(Int128).new(THOU_PREFIXES.size, 0)
      (0...ths.size).reverse_each do |idx|
        n, ths[idx] = n.divmod(1000)
      end
      ths.zip(THOU_PREFIXES).each do |th, pref|
        next if th == 0
        hundreds, rest = th.divmod 100
        s << ONES[hundreds] << " hundred " if hundreds > 0
        if rest < 20
          s << ONES[rest] << " " if rest > 0
        else
          tens, ones = rest.divmod 10
          s << TENS[tens]
          s << "-" << ONES[ones]  if ones > 0
          s << " "
        end
        s << pref << " "  if pref != ""
      end
      s.chomp! 32u8
    end
  end
end

def sequence (io, n)
  words = n.to_words.capitalize
  loop do
    io << words << " is "
    break if n == 4
    n = words.size
    words = n.to_words
    io << words << ", "
  end
  io << "magic."
end

def sequence (n)
  String.build do |s|
    sequence s, n
  end
end

[0, 4, 6, 11, 13, 75, 337, -164, 9_876_543_209, Int128::MAX].each do |start|
  puts "- " + sequence(start)
end
