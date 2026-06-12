def specific (seqs)
  tallies = seqs.map(&.tally)
  tallies.map {|t| t.count {|k, v|
                 v == 2 && tallies.none? {|tt| tt != t && tt[k]? }
               }
  }
end

def specific_graphemes (seqs)
  specific seqs.map &.graphemes
end

def specific_chars (seqs)
  specific seqs.map &.chars
end

def specific_bytes (seqs)
  specific seqs.map &.to_slice
end

def test (seqs)
  puts "#{seqs}: "
  puts "  specific graphemes: #{specific_graphemes(seqs)}, " +
       "chars: #{specific_chars(seqs)}, " +
       "bytes: #{specific_bytes(seqs)}"
end

test ["ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr"]
puts
test ["ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr", "AА🇧🇬ΑAS🤔ää☃☃̂☃o🇬🇧ö🤔👨‍👩‍👧‍👧"]
