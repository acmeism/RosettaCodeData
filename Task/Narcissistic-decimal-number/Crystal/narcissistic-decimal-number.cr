struct Int
  def narcissistic?
    ds = digits
    ds.sum {|d| d ** ds.size } == self
  end
end

p (0..).each.select(&.narcissistic?).first(25).to_a
