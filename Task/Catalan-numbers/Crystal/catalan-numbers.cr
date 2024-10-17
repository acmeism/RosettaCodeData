require "big"
require "benchmark"

def factorial(n : BigInt) : BigInt
  (1..n).product(1.to_big_i)
end

def factorial(n : Int32 | Int64)
  factorial n.to_big_i
end

# direct

def catalan_direct(n)
  factorial(2*n) / (factorial(n + 1) * factorial(n))
end

# recursive

def catalan_rec1(n)
  return 1 if n == 0
  (0...n).reduce(0) do |sum, i|
    sum + catalan_rec1(i) * catalan_rec1(n - 1 - i)
  end
end

def catalan_rec2(n)
  return 1 if n == 0
  2*(2*n - 1) * catalan_rec2(n - 1) / (n + 1)
end

# performance and results

Benchmark.bm do |b|
  b.report("catalan_direct") { 16.times { |n| catalan_direct(n) } }
  b.report("catalan_rec1") { 16.times { |n| catalan_rec1(n) } }
  b.report("catalan_rec2") { 16.times { |n| catalan_rec2(n) } }
end

puts "\n       direct     rec1     rec2"
16.times { |n| puts "%2d :%9d%9d%9d" % [n, catalan_direct(n), catalan_rec1(n), catalan_rec2(n)] }
