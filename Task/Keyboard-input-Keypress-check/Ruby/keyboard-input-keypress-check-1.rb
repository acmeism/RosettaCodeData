begin
  check = STDIN.read_nonblock(1)
rescue IO::WaitReadable
  check = false
end

puts check if check
