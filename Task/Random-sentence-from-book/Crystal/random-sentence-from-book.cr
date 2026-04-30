words = File.read("36-0.txt")
        .sub(/.+^\*\*\* START OF THE .+?\n(.*?)^\*\*\* END OF THE PROJECT .*/m, "\\1")
        .scan(/ \b (?: [[:alpha:]]+’[[:alpha:]]+        # words with apostrophe
                     | [[:alpha:]]+-[[:alpha:]]+’[[:alpha:]]+ # ... & hyphen
                     | [[:alpha:]]+-[[:alpha:]]+        # words with hyphen
                     | [[:alpha:]]+                     # simple words
                     | \d+(?:,\d+)*(?:\.\d+)?           # numbers
                     | [.!?,]                           # punctuation
                   )/x).map &.to_s

def make_pair_counter
  Hash(String, Hash(String, Int32)).new {|h, k|
    h[k] = Hash(String, Int32).new(0)
  }
end

def make_triad_counter
  Hash(String, Hash(String, Hash(String, Int32))).new {|h, k|
    h[k] = make_pair_counter
  }
end

pairs = make_pair_counter
triads = make_triad_counter

words.each_cons_pair do |w1, w2|
  pairs[w1][w2] += 1
end

words.each_cons(3, reuse: true) do |(w1, w2, w3)|
  triads[w1][w2][w3] += 1
end

def weighted_choice (hash)
  n = Random.rand(hash.values.sum)
  hash.each do |k, v|
    n -= v
    return k if n <= 0
  end
  raise "?"
end

10.times do
  sentence = [ weighted_choice(pairs["."]) ]
  sentence << weighted_choice(pairs[sentence[0]])

  loop do
    break if sentence[-1].in? [".", "?", "!"]
    sentence << weighted_choice(triads[sentence[-2]][sentence[-1]])
  end
  puts sentence.join(" ").gsub(/ ([,!?.])/, "\\1")
end
