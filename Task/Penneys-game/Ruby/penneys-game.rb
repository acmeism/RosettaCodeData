#  Penney's Game

Toss = [:Heads, :Tails]

def yourChoice
  puts "Enter your choice (H/T)"
  choice = []
  3.times do
    until (c = $stdin.getc.upcase) == "H" or c == "T"
    end
    choice << (c=="H" ? Toss[0] : Toss[1])
  end
  puts "You chose #{choice.join(' ')}"
  choice
end

puts "%s I start, %s you start ..... #{coin = Toss.sample}" % Toss
if coin == Toss[0]
  myC = Array.new(3){Toss.sample}
  puts "I chose #{myC.join(' ')}"
  yC = yourChoice
else
  yC = yourChoice
  myC = Toss - [yC[1]] + yC.first(2)
  puts "I chose #{myC.join(' ')}"
end

seq = Array.new(3){Toss.sample}
print seq.join(' ')
loop do
  puts "\n I win!" or break   if seq == myC
  puts "\n You win!" or break if seq == yC
  seq.push(Toss.sample).shift
  print " #{seq[-1]}"
end
