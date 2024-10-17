require "big"

EXPECTED = (1..9).map{ |d| Math.log10(1 + 1.0 / d) }

def fib(n)
  a, b = 0.to_big_i, 1.to_big_i
  (0...n).map { ret, a, b = a, b, a + b; ret }
end

# powers of 3 as a test sequence
def power_of_threes(n)
  (0...n).map { |k| 3.to_big_i ** k }
end

def heads(s)
  s.map { |a| a.to_s[0].to_i }
end

def show_dist(title, s)
  s = heads(s)
  c = Array.new(10, 0)
  s.each{ |x| c[x] += 1 }
  siz = s.size
  res = (1..9).map{ |d| c[d] / siz }
  puts "\n    %s Benfords deviation" % title
  res.zip(EXPECTED).each_with_index(1) do |(r, e), i|
    puts "%2d: %5.1f%%  %5.1f%%  %5.1f%%" % [i, r*100, e*100, (r - e).abs*100]
  end
end

def random(n)
  (0...n).map { |i| rand(1..n) }
end

show_dist("fibbed", fib(1000))
show_dist("threes", power_of_threes(1000))

# just to show that not all kind-of-random sets behave like that
show_dist("random", random(10000))
