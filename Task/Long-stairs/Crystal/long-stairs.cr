trials = 10000
t_total = s_total = 0

puts "Seconds  steps behind  steps ahead"

trials.times do |i|
  stairs = 100
  location = 0
  seconds = 0

  loop do
    seconds += 1
    location += 1
    break if location > stairs
    (1..stairs).sample(5).each do |roll|
      location += 1 if roll <= location
      stairs += 1
    end
    puts "  #{seconds}        #{location}         #{stairs-location}" if i == 0 && (600..609).includes?(seconds)
  end

  t_total += seconds
  s_total += stairs
end

puts "Average seconds: #{t_total/trials},  Average steps: #{s_total/trials}"
