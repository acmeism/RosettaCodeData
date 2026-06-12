for word in "unixdict.txt".lines:
  if word.len > 5:
    if word[0..2] == word[^3..^1]:
      echo word
