f = [nil, nil, :Fizz].cycle
b = [nil, nil, nil, nil, :Buzz].cycle
(1..100).each do |i|
  puts "#{f.next}#{b.next}"[/.+/] || i
end
