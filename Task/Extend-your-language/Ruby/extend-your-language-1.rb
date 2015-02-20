# Define a class which always returns itself for everything
class HopelesslyEgocentric
  def method_missing(what, *args) self end
end

def if2(cond1, cond2)
  if cond1 and cond2
    yield
    HopelesslyEgocentric.new
  elsif cond1
    Class.new(HopelesslyEgocentric) do
      def else1; yield; HopelesslyEgocentric.new end
    end.new
  elsif cond2
    Class.new(HopelesslyEgocentric) do
      def else2; yield; HopelesslyEgocentric.new end
    end.new
  else
    Class.new(HopelesslyEgocentric) do
      def neither; yield end
    end.new
  end
end
