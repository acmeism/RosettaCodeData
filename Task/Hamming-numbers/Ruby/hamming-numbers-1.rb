require 'generator'

# the Hamming number generator
hamming = Generator.new do |generator|
  next_ham = 1
  queues = { 2 => [], 3 => [], 5 => [] }
  loop do
    generator.yield next_ham

    [2,3,5].each {|m| queues[m] << (next_ham * m)}
    next_ham = [2,3,5].collect {|m| queues[m][0]}.min
    [2,3,5].each {|m| queues[m].shift if queues[m][0] == next_ham}
  end
end
