File.open("input.txt") do |file|
  file.each_char { |c| p c }
end
