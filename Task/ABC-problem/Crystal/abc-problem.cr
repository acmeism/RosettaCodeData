def can_make_word? (word, blocks, i=0)
  return true if word.empty?
  ch = word[0].upcase
  blocks.each_with_index do |block, idx|
    if ch.in? block.upcase
      return true if can_make_word? word[1..], blocks[...idx] + blocks[(idx+1)..], i+1
    end
  end
  false
end

blocks = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM".split

["A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"].each do |word|
  print word, " -> ", can_make_word?(word, blocks), "\n"
end
print "abba", " -> ", can_make_word?("abba", ["AB", "AB", "AC", "AC"]), "\n"
