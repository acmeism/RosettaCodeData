File.new("unixdict.txt").each do |word|
  puts word if word.count("e") > 3 && word.count("aiou") == 0
end
