class Integer
  def narcissistic?
    return false if self < 0
    len = to_s.size
    n = self
    sum = 0
    while n > 0
      n, r = n.divmod(10)
      sum += r ** len
    end
    sum == self
  end
end

numbers = []
n = 0
while numbers.size < 25
  numbers << n if n.narcissistic?
  n += 1
end

# or
# numbers = 0.step.lazy.select(&:narcissistic?).first(25)   # Ruby ver 2.1

max = numbers.max.to_s.size
g = numbers.group_by{|n| n.to_s.size}
g.default = []
(1..max).each{|n| puts "length #{n} : #{g[n].join(", ")}"}
