class Integer
  def narcissistic?
    return false if negative?
    digs = self.digits
    m    = digs.size
    digs.sum{|d| d**m} == self
  end
end

puts 0.step.lazy.select(&:narcissistic?).first(25)
