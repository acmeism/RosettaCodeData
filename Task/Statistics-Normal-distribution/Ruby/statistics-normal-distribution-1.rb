# Class to implement a Normal distribution, generated from a Uniform distribution.
# Uses the Marsaglia polar method.

class NormalFromUniform
  # Initialize an instance.
  def initialize()
    @next = nil
  end
  # Generate and return the next Normal distribution value.
  def rand()
    if @next
      retval, @next = @next, nil
      return retval
    else
      u = v = s = nil
      loop do
        u = Random.rand(-1.0..1.0)
        v = Random.rand(-1.0..1.0)
        s = u**2 + v**2
        break if (s > 0.0) && (s <= 1.0)
      end
      f = Math.sqrt(-2.0 * Math.log(s) / s)
      @next = v * f
      return u * f
    end
  end
end
