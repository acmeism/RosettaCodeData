File.write("input.txt", "a\nb\nc")

lines = Channel(String).new

spawn do
  File.each_line("input.txt") do |line|
    lines.send(line)
  end
  lines.close
end

while line = lines.receive?
  puts line
end

File.delete("input.txt")
