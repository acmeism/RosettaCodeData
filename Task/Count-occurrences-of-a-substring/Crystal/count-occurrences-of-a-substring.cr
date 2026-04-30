def count_substring (haystack, needle)
  count = 0
  needle_size = needle.size
  i = 0
  while i = haystack.index(needle, i)
    i += needle_size
    count += 1
  end
  count
end

p count_substring "the three truths", "th"
p count_substring "ababababab", "abab"
