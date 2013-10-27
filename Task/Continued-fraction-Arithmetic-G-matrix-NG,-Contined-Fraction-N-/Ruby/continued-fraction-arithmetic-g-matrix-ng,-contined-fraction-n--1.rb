# I define a class to implement baby NG
class NG
  def initialize(a1, a, b1, b)
    @a1, @a, @b1, @b = a1, a, b1, b
  end
  def ingress(n)
    @a, @a1 = @a1, @a + @a1 * n
    @b, @b1 = @b1, @b + @b1 * n
  end
  def needterm?
    return true if @b == 0 or @b1 == 0
    return true unless @a/@b == @a1/@b1
    false
  end
  def egress
    n = @a / @b
    @a,  @b  = @b,  @a  - @b  * n
    @a1, @b1 = @b1, @a1 - @b1 * n
    n
  end
  def egress_done
    @a, @b = @a1, @b1 if needterm?
    egress
  end
  def done?
    @b == 0 and @b1 == 0
  end
end
