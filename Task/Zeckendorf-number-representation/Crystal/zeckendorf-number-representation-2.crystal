class ZeckendorfIterator
  include Iterator(String)

  def initialize
    @x = 0
  end

  def next
    bin = @x.to_s(2)
    @x += 1
    while bin.includes?("11")
      bin = @x.to_s(2)
      @x += 1
    end
    bin
  end
end

def zeckendorf(n)
  ZeckendorfIterator.new.first(n)
end

zeckendorf(21).each_with_index{ |x,i| puts "%3d: %8s"% [i, x] }
