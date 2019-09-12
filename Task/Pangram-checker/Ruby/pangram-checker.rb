def pangram?(sentence)
  ('a'..'z').all? {|chars| sentence.downcase.include? (chars) }
end

p pangram?('this is a sentence')  # ==> false
p pangram?('The quick brown fox jumps over the lazy dog.')  # ==> true
