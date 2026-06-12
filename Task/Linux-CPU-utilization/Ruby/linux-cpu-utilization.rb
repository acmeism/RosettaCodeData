puts "Ctrl-c to exit"
loop do
  str = File.open("/proc/stat").readline
  ar = str.split[1..].map(&:to_f)
  idle = ar[3] / ar.sum
  cpu = ((1-idle)*100).round(5)
  puts "CPU: #{cpu}%\r"
  sleep 5
end
