File.open("unixdict.txt") do |f|
  f.each_line do |line| puts line if line.size > 11 && line =~ /the/ end
end
