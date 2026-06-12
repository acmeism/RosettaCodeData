module TWL
  abstract class WordList
    abstract def from_number (n)
    abstract def from_word (w)

    def [] (w_or_n)
      if w_or_n.is_a?(Int)
        from_number(w_or_n)
      elsif w_or_n.is_a?(String)
        from_word(w_or_n)
      else
        raise "invalid argument"
      end
    end

    Standard = StandardWordList.new
  end

  class StandardWordList < WordList
    def from_number (n)
      sprintf "W%05d", n
    end
    def from_word (w)
      w =~ /^W(\d{5})$/ && $1.to_i || raise "invalid word"
    end
  end

  class FileWordList < WordList
    @words : Array(String)
    def initialize (fn, min_length = 6, max_length = 6)
      @words = File.open(fn) do |f|
        f.each_line.select {|w| min_length <= w.size <= max_length }
          .first(28126).to_a.sort!
      end
    end
    def from_number (n)
      @words[n]
    end
    def from_word (w)
      idx = @words.bsearch_index {|word, _| word >= w }
      return idx if idx && @words[idx] == w
      raise "invalid word #{w}"
    end
  end

  def self.from_latitude (lat, lon, wlist = WordList::Standard)
    ilat = (lat * 10000).to_i64 + 900000
    ilon = (lon * 10000).to_i64 + 1800000
    n = (ilat << 22) + ilon
    i1 = n >> 28
    i2 = (n >> 14) & 0x3fff
    i3 = n & 0x3fff

    { wlist[i1], wlist[i2], wlist[i3] }
  end

  def self.from_words (word1, word2, word3, wlist = WordList::Standard)
    i1 = wlist[word1].to_i64
    i2 = wlist[word2].to_i64
    i3 = wlist[word3].to_i64
    n = (i1 << 28) + (i2 << 14) + i3
    ilat = n >> 22
    ilon = n & 0x3fffff
    lat = (ilat - 900000) / 10000
    lon = (ilon - 1800000) / 10000
    { lat, lon}
  end
end

word_list = TWL::FileWordList.new "words_alpha.txt"

[{ 28.3852,    -81.5638,   "Task location" },
 { 51.4337,     -0.2141,   "Wimbledon"},
 { 21.2596,   -157.8117,   "Diamond Head crater"},
 {-55.9652,    -67.2256,   "Monumento Cabo De Hornos"},
 { 71.170924,   25.782998, "Nordkapp, Norway"},
 { 45.762983,    4.834520, "Café Perl, Lyon"},
 { 48.391541, -124.736731, "Cape Flattery Lighthouse, Tatoosh Island"}
].each do |lat, lon, desc|
  puts "Coordinates: #{lat}, #{lon}  (#{desc})"
  words1 = TWL.from_latitude(lat, lon)
  words2 = TWL.from_latitude(lat, lon, word_list)
  print "  To 3-word: ", words1.join(" "), " ~ ", words2.join(" "), "\n"
  latlon1 = TWL.from_words *words1
  latlon2 = TWL.from_words *words2, word_list
  print "From 3-words (1): ", latlon1.join(","), "\n"
  print "From 3-words (2): ", latlon2.join(","), "\n"
  puts
end
