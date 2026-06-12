File.read("unixdict.txt").each_line.select(/^[^bc]*a[^c]*b.*c/).each do |word|
  puts word
end
