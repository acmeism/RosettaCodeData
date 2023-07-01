require "prime"

class Integer

  def smith?
    return false if prime?
    digits.sum == prime_division.map{|pr,n| pr.digits.sum * n}.sum
  end

end

n   = 10_000
res = 1.upto(n).select(&:smith?)

puts "#{res.size} smith numbers below #{n}:
#{res.first(5).join(", ")},... #{res.last(5).join(", ")}"
