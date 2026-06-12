struct Int
  THOU_PREFIXES = %w(undec dec non oct sept sext quint quadr tr b m)
                  .map(&.+("illion")) + ["thousand", ""]
  TENS = ["", ""] + %w(twen thir for fif six seven eigh nine).map &.+("ty")
  ONES = [""] + %w(one two three four five six seven eight nine ten) +
         %w(eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
  def to_words
    raise "Number too big to express in words" unless self.abs <= Int128::MAX
    return "zero" if self == 0
    String.build do |s|
      n = self
      if n < 0
        s << "minus "
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

RAN = Set(String).new

def once (&)
  yield if RAN.add? caller[1]
end

[1000, 10000].each do |limit|
  eca = Hash(String, Array(Int32)).new {|h, k| h[k] = [] of Int32 }
  (0...limit).each do |n|
    eca[ n.to_words.chars.sort!.join ] << n
  end
  once do
    puts "\nFirst 30 English cardinal anagrams:\n " +
         eca.select {|_, v| v.size > 1}.values.flatten.uniq.sort.first(30)
           .map {|n| "%3d" % n }.each_slice(10).map(&.join " ").join "\n "
  end

  puts "\nCount of English cardinal anagrams up to #{limit.format}: " +
       eca.count {|_, v| v.size > 1}.to_s

  max_size = eca.values.max_of &.size
  puts "\nLargest group(s) of English cardinal anagrams up to #{limit.format}:\n " +
       eca.values.select {|v| v.size == max_size }.join "\n "
end
