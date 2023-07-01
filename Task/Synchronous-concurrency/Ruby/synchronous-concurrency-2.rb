count = 0
reader = Fiber.new do
  IO.foreach("input.txt") { |line| Fiber.yield line }
  puts "Printed #{count} lines."
  nil
end

# printer
while line = reader.resume
  print line
  count += 1
end
