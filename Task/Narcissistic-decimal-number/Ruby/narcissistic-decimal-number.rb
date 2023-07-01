class Integer
  def narcissistic?
    return false if negative?
    digs = self.digits
    m    = digs.size
    digs.map{|d| d**m}.sum == self
  end
end

puts 0.step.lazy.select(&:narcissistic?).first(25)
