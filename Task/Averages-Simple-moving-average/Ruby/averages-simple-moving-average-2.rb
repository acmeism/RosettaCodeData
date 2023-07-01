class MovingAverager
  def initialize(size)
    @size = size
    @nums = []
    @sum = 0.0
  end
  def <<(hello)
    @nums << hello
    goodbye = @nums.length > @size ? @nums.shift : 0
    @sum += hello - goodbye
    self
  end
  def average
    @sum / @nums.length
  end
  alias to_f average
  def to_s
    average.to_s
  end
end

ma3 = MovingAverager.new(3)
ma5 = MovingAverager.new(5)

(1.upto(5).to_a + 5.downto(1).to_a).each do |num|
  printf "Next number = %d, SMA_3 = %.3f, SMA_5 = %.1f\n",
    num, ma3 << num, ma5 <<num
end
