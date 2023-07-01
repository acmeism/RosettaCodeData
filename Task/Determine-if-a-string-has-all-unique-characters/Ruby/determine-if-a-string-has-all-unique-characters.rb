strings = ["",
        ".",
        "abcABC",
        "XYZ ZYX",
        "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
        "01234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ0X",
        "hétérogénéité",
        "🎆🎃🎇🎈",
        "😍😀🙌💃😍🙌",
        "🐠🐟🐡🦈🐬🐳🐋🐡",]

strings.each do |str|
  seen = {}
  print "#{str.inspect} (size #{str.size}) "
  res = "has no duplicates." #may change
  str.chars.each_with_index do |c,i|
    if seen[c].nil?
      seen[c] = i
    else
      res =  "has duplicate char #{c} (#{'%#x' % c.ord}) on #{seen[c]} and #{i}."
      break
    end
  end
  puts res
end
