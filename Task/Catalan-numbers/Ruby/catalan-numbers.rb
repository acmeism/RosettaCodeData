def factorial(n)
  (1..n).reduce(1, :*)
end

# direct

def catalan_direct(n)
  factorial(2*n) / (factorial(n+1) * factorial(n))
end

# recursive

def catalan_rec1(n)
  return 1 if n == 0
  (0...n).inject(0) {|sum, i| sum + catalan_rec1(i) * catalan_rec1(n-1-i)}
end

def catalan_rec2(n)
  return 1 if n == 0
  2*(2*n - 1) * catalan_rec2(n-1) / (n+1)
end

# performance and results

require 'benchmark'
require 'memoize'
include Memoize

Benchmark.bm(17) do |b|
  b.report('catalan_direct')    {16.times {|n| catalan_direct(n)} }
  b.report('catalan_rec1')      {16.times {|n| catalan_rec1(n)} }
  b.report('catalan_rec2')      {16.times {|n| catalan_rec2(n)} }

  memoize :catalan_rec1
  b.report('catalan_rec1(memo)'){16.times {|n| catalan_rec1(n)} }
end

puts "\n       direct     rec1     rec2"
16.times {|n| puts "%2d :%9d%9d%9d" % [n, catalan_direct(n), catalan_rec1(n), catalan_rec2(n)]}
