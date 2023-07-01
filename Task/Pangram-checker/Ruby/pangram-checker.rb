def pangram?(sentence)
  s = sentence.downcase
  ('a'..'z').all? {|char| s.include? (char) }
end

p pangram?('this is a sentence')  # ==> false
p pangram?('The quick brown fox jumps over the lazy dog.')  # ==> true
