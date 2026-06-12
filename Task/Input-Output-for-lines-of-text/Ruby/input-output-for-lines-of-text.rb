def do_stuff(line)
  puts line
end

n = gets.to_i
n.times do
  line = gets
  do_stuff(line)
end
