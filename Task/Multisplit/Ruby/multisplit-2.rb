def multisplit(text, separators)
  sep_regex = Regexp.new(separators.collect {|sep| Regexp.escape(sep)}.join('|'))
  separator_info = []
  pieces = []
  i = prev = 0
  while i = text.index(sep_regex, i)
    separator = Regexp.last_match(0)
    pieces << text[prev .. i-1]
    separator_info << [separator, i]
    i = i + separator.length
    prev = i
  end
  pieces << text[prev .. -1]
  [pieces, separator_info]
end

p multisplit(text, separators)
# => [["a", "", "b", "", "c"], [["!=", 1], ["==", 3], ["=", 6], ["!=", 7]]]
