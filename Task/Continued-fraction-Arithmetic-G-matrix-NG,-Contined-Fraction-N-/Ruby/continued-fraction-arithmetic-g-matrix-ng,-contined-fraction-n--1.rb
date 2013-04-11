=begin
  I define a class to implement baby NG
  Nigel Galloway February 6th., 2013
=end
class NG
  def initialize(a1, a, b1, b)
    @a1 = a1; @a = a; @b1 = b1; @b = b;
  end
  def ingress(n)
    t=@a; @a=@a1; @a1=t + @a1 * n; t=@b; @b=@b1; @b1=t + @b1 * n;
  end
  def needterm?
    return true if @b1 == 0 or @b == 0
    return true unless @a/@b == @a1/@b1
    return false
  end
  def egress
    n = @a/@b
    t=@a; @a=@b; @b=t - @b * n; t=@a1; @a1=@b1; @b1=t - @b1 * n;
    return n
  end
  def egress_done
    if needterm? then @a=@a1; @b=@b1 end
    return egress
  end
  def done?
    if @b1 == 0 and @b == 0 then return true else return false end
  end
end
