filename = "|strange-name.txt"
File.open(filename) do |file|
  file.each {|line| puts line}
end
