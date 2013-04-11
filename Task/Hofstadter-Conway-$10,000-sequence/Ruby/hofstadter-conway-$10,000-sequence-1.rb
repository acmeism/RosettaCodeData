class HofstadterConway10000
  def initialize
    @sequence = [nil, 1, 1]
  end
  attr_reader :sequence

  def [](n)
    raise ArgumentError, "n must be >= 1" if n < 1
    a = @sequence
    a.length.upto(n) {|i| a[i] = a[a[i-1]] + a[i-a[i-1]] }
    a[n]
  end
end

hc = HofstadterConway10000.new
