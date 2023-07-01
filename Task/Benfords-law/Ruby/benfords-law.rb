EXPECTED = (1..9).map{|d| Math.log10(1+1.0/d)}

def fib(n)
  a,b = 0,1
  n.times.map{ret, a, b = a, b, a+b; ret}
end

# powers of 3 as a test sequence
def power_of_threes(n)
  n.times.map{|k| 3**k}
end

def heads(s)
  s.map{|a| a.to_s[0].to_i}
end

def show_dist(title, s)
  s = heads(s)
  c = Array.new(10, 0)
  s.each{|x| c[x] += 1}
  size = s.size.to_f
  res = (1..9).map{|d| c[d]/size}
  puts "\n    %s Benfords deviation" % title
  res.zip(EXPECTED).each.with_index(1) do |(r, e), i|
    puts "%2d: %5.1f%%  %5.1f%%  %5.1f%%" % [i, r*100, e*100, (r - e).abs*100]
  end
end

def random(n)
  n.times.map{rand(1..n)}
end

show_dist("fibbed", fib(1000))
show_dist("threes", power_of_threes(1000))

# just to show that not all kind-of-random sets behave like that
show_dist("random", random(10000))
