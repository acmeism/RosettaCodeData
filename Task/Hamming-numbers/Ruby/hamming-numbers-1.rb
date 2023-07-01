hamming = Enumerator.new do |yielder|
  next_ham = 1
  queues = [[ 2, []], [3, []], [5, []] ]

  loop do
    yielder << next_ham   # or: yielder.yield(next_ham)

    queues.each {|m,queue| queue << next_ham * m}
    next_ham = queues.collect{|m,queue| queue.first}.min
    queues.each {|m,queue| queue.shift if queue.first==next_ham}
  end
end
