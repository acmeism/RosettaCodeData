class Integer
  def reverse
    to_s.reverse.to_i
  end
  def divisors
      res = []
      (1..Integer.sqrt(self)).each do |cand|
        div, mod = self.divmod(cand)
        res << cand << div if mod == 0
      end
      res.uniq.sort
  end
  def special_divisors?
    r = self.reverse
    divisors.all?{|d| r % d.reverse == 0}
  end
end

p (1..200).select(&:special_divisors?)
