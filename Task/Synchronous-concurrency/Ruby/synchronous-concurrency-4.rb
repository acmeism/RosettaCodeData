require 'thread'

counts = Queue.new
lines = Queue.new
reader = Thread.new do
  begin
    File.foreach("input.txt") { |line| lines << line }
    lines << :EOF
    puts "Printed #{counts.pop} lines."
  ensure
    lines << nil
  end
end

# writer
count = 0
while line = lines.pop
  case line
  when String
    print line
    count += 1
  when :EOF
    counts << count
  end
end
reader.join
