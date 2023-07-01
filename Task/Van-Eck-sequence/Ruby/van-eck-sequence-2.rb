class VenEch
  include Enumerable

  def initialize()
    @i = 0;
    @val = 0;
    @seen = {};
  end

  def add_num num
    @val = @i - @seen.fetch(num, @i)
    @seen[num] = @i
    @i += 1
  end

  def each(&block)
    loop { block.call(@val); add_num @val }
  end
end

ve = VenEch.new.take(1000)
p ve.first(10), ve.last(10)
