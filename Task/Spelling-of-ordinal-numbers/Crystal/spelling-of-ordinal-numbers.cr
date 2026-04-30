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

  ORDINALS = { "one" => "first", "two" => "second", "three" => "third",
               "five" => "fifth", "eight" => "eighth", "nine" => "ninth",
               "twelve" => "twelfth", "ty" => "tieth" }
  def to_ordinal
    result = to_words
    if rule = ORDINALS.find {|ending, _| result.ends_with? ending }
      ending, replacement = rule
      result.chomp(ending) + replacement
    else
      result + "th"
    end
  end
end

[1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003].each do |n|
  print " ", n, ": ", n.to_ordinal, "\n"
end
