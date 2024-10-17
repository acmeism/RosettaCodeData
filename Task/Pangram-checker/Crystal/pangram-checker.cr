def pangram?(sentence)
  ('a'..'z').all? {|c| sentence.downcase.includes?(c) }
end

p pangram?("not a pangram")
p pangram?("The quick brown fox jumps over the lazy dog.")
