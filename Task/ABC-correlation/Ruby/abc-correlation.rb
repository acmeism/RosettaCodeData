def str_corr(str, to_count)
  str.chars.select{|c| to_count[c] }.tally.values.uniq.size == 1
end

p str_corr("abcabdc", "abc")
