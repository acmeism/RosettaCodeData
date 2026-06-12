File.open("unixdict.txt") do |f|
  f.each_line do |line|
    puts line  if line.size > 5 && line[..2] == line[-3..]
  end
end
