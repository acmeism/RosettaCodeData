struct Int
  def perfect?
    zero = typeof(self).new(0)
    self == (zero+1 .. self//2).sum(zero) {|i| self % i == 0 ? i : 0 }
  end
end

p (1..10_000).select(&.perfect?).to_a
