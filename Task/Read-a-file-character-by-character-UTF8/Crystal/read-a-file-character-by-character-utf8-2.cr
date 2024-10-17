File.open("input.txt") do |file|
  while c = file.read_char
    p c
  end
end
