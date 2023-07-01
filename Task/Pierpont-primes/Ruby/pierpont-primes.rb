require 'gmp'

def  smooth_generator(ar)
  return to_enum(__method__, ar) unless block_given?
  next_smooth = 1
  queues = ar.map{|num| [num, []] }
  loop do
    yield next_smooth
    queues.each {|m, queue| queue << next_smooth * m}
    next_smooth = queues.collect{|m, queue| queue.first}.min
    queues.each{|m, queue| queue.shift if queue.first == next_smooth }
  end
end

def pierpont(num = 1)
    return to_enum(__method__, num) unless block_given?
    smooth_generator([2,3]).each{|smooth| yield smooth+num if GMP::Z(smooth + num).probab_prime? > 0}
end

def puts_cols(ar, n=10)
  ar.each_slice(n).map{|slice|puts  slice.map{|n| n.to_s.rjust(10)}.join }
end

n, m = 50, 250
puts "First #{n} Pierpont primes of the first kind:"
puts_cols(pierpont.take(n))
puts "#{m}th Pierpont prime of the first kind: #{pierpont.take(250).last}",""
puts "First #{n} Pierpont primes of the second kind:"
puts_cols(pierpont(-1).take(n))
puts "#{m}th Pierpont prime of the second kind: #{pierpont(-1).take(250).last}"
