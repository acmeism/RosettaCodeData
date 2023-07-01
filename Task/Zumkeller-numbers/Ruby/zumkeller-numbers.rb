class Integer

  def divisors
    res = [1, self]
    (2..Integer.sqrt(self)).each do |n|
      div, mod = divmod(n)
      res << n << div if mod.zero?
    end
    res.uniq.sort
  end

  def zumkeller?
    divs = divisors
    sum  = divs.sum
    return false unless sum.even? && sum >= self*2
    half = sum / 2
    max_combi_size = divs.size / 2
    1.upto(max_combi_size).any? do |combi_size|
      divs.combination(combi_size).any?{|combi| combi.sum == half}
    end
  end

end

def p_enum(enum, cols = 10, col_width = 8)
  enum.each_slice(cols) {|slice| puts "%#{col_width}d"*slice.size % slice}
end

puts "#{n=220} Zumkeller numbers:"
p_enum 1.step.lazy.select(&:zumkeller?).take(n), 14, 6

puts "\n#{n=40} odd Zumkeller numbers:"
p_enum 1.step(by: 2).lazy.select(&:zumkeller?).take(n)

puts "\n#{n=40} odd Zumkeller numbers not ending with 5:"
p_enum 1.step(by: 2).lazy.select{|x| x % 5 > 0 && x.zumkeller?}.take(n)
