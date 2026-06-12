TENS = { "twenty" => 20, "thirty" => 30, "forty" => 40, "fifty" => 50,
         "sixty" => 60, "seventy" => 70, "eighty" => 80, "ninety" => 90 }
ONES = { "single" => 1, "one" => 1, "two" => 2, "three" => 3, "four" => 4,
         "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9,
         "ten" => 10, "eleven" => 11, "twelve" => 12, "thirteen" => 13,
         "fourteen" => 14, "fifteen" => 15, "sixteen" => 16,
         "seventeen" => 17, "eighteen" => 18, "nineteen" => 19 }
NUMBERS = TENS.merge ONES

RxTENS = Regex.union(TENS.keys)
RxONES = Regex.union(ONES.keys)

PUNCT = { "apostrophe" => "'", "comma" => ",", "hyphen" => "-", "exclamation" => "!" }

def autogram? (s, punct)
  stated = Hash(Char, Int32).new
  s = s.downcase
  s.scan(%r{(?: (?: (#{RxTENS}) [ -]? (#{RxONES}) ) | (#{RxTENS}|#{RxONES}) ) \s+
            (#{PUNCT.keys.join('|')}|[[:punct:]a-z]) (?: '? s )? (?: \b|$|\s|[[:punct:]] )
           }x) do |m|
    letter = (PUNCT[m[4]]? || m[4])[0]
    n = (1..3).reduce(0) {|sum, i| sum + (NUMBERS[ m[i]? ]? || 0) }
    stated[letter] = n
  end
  real = s.chars.tally
  real.delete ' '
  unless punct
    real.keys.reject(&.alphanumeric?).each do |k| real.delete(k) end
  end
  real == stated
end

[ {"This sentence employs two a's, two c's, two d's, twenty-eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty-five s's, twenty-three t's, six v's, ten w's, two x's, five y's, and one z.", false},
  {"This sentence employs two a's, two c's, two d's, twenty eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's, ten w's, two x's, five y's, and one z.", false},
  {"Only the fool would take trouble to verify that his sentence was composed of ten a's, three b's, four c's, four d's, forty-six e's, sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's, four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's, forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's, eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens and, last but not least, a single !", true},
  {"This pangram contains four as, one b, two cs, one d, thirty es, six fs, five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns, fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us, seven vs, eight ws, two xs, three ys, & one z.", false},
  {"This sentence contains one hundred and ninety-seven letters: four a's, one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's, twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's, nineteen t's, six u's, seven v's, four w's, four x's, five y's, and one z.", false},
  {"Thirteen e's, five f's, two g's, five h's, eight i's, two l's, three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's, six w's, four x's, two y's.", false},
  {"Fifteen e's, seven f's, four g's, six h's, eight i's, four n's, five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's, three x's.", true},
  {"Sixteen e's, five f's, three g's, six h's, nine i's, five n's, four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's, four z's.", false}
].each do |s, punct|
  puts "The sentence"
  puts s.gsub(/(.{78})\s/, "\\1\n").gsub(/(^|\n)/, "\\1    ")  # this just wraps the sentence
  puts (autogram?(s, punct) ? "is " : "isn't ") + (punct ? "a punctuation-including" : "an") + " autogram."
  puts
end
