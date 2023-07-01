# Class implementing the Formal Power Series type.

class Fps

  # Initialize the FPS instance.
  # When nothing specified, all coefficients are 0.
  # When const: specifies n, all coefficients are n.
  # When delta: specifies n, a[0] = n, then all higher coefficients are zero.
  # When iota: specifies n, coefficients are consecutive integers, beginning with a[0] = n.
  # When init: specifies an array, coefficients are the array elements, padded with zeroes.
  # When enum: specifies a lazy enumerator, that is used for the internal coefficients enum.
  def initialize(const: nil, delta: nil, iota: nil, init: nil, enum: nil)
    # Create (or save) the specified coefficient enumerator.
    case
      when const
        @coeffenum = make_const(const)
      when delta
        @coeffenum = make_delta(delta)
      when iota
        @coeffenum = make_iota(iota)
      when init
        @coeffenum = make_init(init)
      when enum
        @coeffenum = enum
      else
        @coeffenum = make_const(0)
    end
    # Extend the coefficient enumerator instance with an element accessor.
    @coeffenum.instance_eval do
      def [](index)
        self.drop(index).first
      end
    end
  end

  # Return the coefficient at the given index.
  def [](index)
    @coeffenum.drop(index).first
  end

  # Return sum: this FPS plus the given FPS.
  def +(other)
    other = convert(other)
    Fps.new(enum:
      Enumerator.new do |yielder, inx: 0|
        loop do
          yielder.yield(@coeffenum[inx] + other[inx])
          inx += 1
        end
      end.lazy)
  end

  # Return difference: this FPS minus the given FPS.
  def -(other)
    other = convert(other)
    Fps.new(enum:
      Enumerator.new do |yielder, inx: 0|
        loop do
          yielder.yield(@coeffenum[inx] - other[inx])
          inx += 1
        end
      end.lazy)
  end

  # Return product: this FPS multiplied by the given FPS.
  def *(other)
    other = convert(other)
    Fps.new(enum:
      Enumerator.new do |yielder, inx: 0|
        loop do
          coeff = (0..inx).reduce(0) { |sum, i| sum + (@coeffenum[i] * other[inx - i]) }
          yielder.yield(coeff)
          inx += 1
        end
      end.lazy)
  end

  # Return quotient: this FPS divided by the given FPS.
  def /(other)
    other = convert(other)
    Fps.new(enum:
      Enumerator.new do |yielder, inx: 1|
        coeffs = [ Rational(@coeffenum[0], other[0]) ]
        yielder.yield(coeffs[-1])
        loop do
          coeffs <<
            Rational(
              @coeffenum[inx] -
                (1..inx).reduce(0) { |sum, i| sum + (other[i] * coeffs[inx - i]) },
              other[0])
          yielder.yield(coeffs[-1])
          inx += 1
        end
      end.lazy)
  end

  # Return the derivative of this FPS.
  def deriv()
    Fps.new(enum:
      Enumerator.new do |yielder, inx: 0|
        iota = Fps.new(iota: 1)
        loop do
          yielder.yield(@coeffenum[inx + 1] * iota[inx])
          inx += 1
        end
      end.lazy)
  end

  # Return the integral of this FPS.
  def integ()
    Fps.new(enum:
      Enumerator.new do |yielder, inx: 0|
        iota = Fps.new(iota: 1)
        yielder.yield(Rational(0, 1))
        loop do
          yielder.yield(Rational(@coeffenum[inx], iota[inx]))
          inx += 1
        end
      end.lazy)
  end

  # Assign a new value to an existing FPS instance.
  def assign(other)
    other = convert(other)
    @coeffenum = other.get_enum
  end

  # Coerce a Numeric into an FPS instance.
  def coerce(other)
    if other.kind_of?(Numeric)
      [ Fps.new(delta: other), self ]
    else
      raise TypeError 'non-numeric can\'t be coerced into FPS type'
    end
  end

  # Convert to Integer.  (Truncates to 0th coefficient.)
  def to_i()
    @coeffenum[0].to_i
  end

  # Convert to Float.  (Truncates to 0th coefficient.)
  def to_f()
    @coeffenum[0].to_f
  end

  # Convert to Rational.  (Truncates to 0th coefficient.)
  def to_r()
    @coeffenum[0].to_r
  end

  # Convert to String the first count terms of the FPS.
  def to_s(count = 0)
    if count <= 0
      super()
    else
      retstr = ''
      count.times do |inx|
        coeff = (@coeffenum[inx].to_r.denominator == 1) ? @coeffenum[inx].to_i : @coeffenum[inx]
        if !(coeff.zero?)
          prefix = (retstr != '') ? ' ' : ''
          coeffstr =
            ((coeff.abs == 1) && (inx != 0)) ? '' : "#{coeff.abs.to_s}#{(inx == 0) ? '' : '*'}"
          suffix = (inx == 0) ? '' : (inx == 1) ? 'x' : "x^#{inx}"
          if coeff < 0
            prefix << ((retstr != '') ? '- ' : '-')
          else
            prefix << ((retstr != '') ? '+ ' : '')
          end
          retstr << "#{prefix}#{coeffstr}#{suffix}"
        end
      end
      (retstr == '') ? '0' : retstr
    end
  end

  # Evaluate this FPS at the given x value to the given count of terms.
  def eval(x, count)
    @coeffenum.first(count).each_with_index.reduce(0) { |sum, (coeff, inx) | sum + coeff * x**inx }
  end

  # Forward method calls to the @coeffenum instance.
  def method_missing(name, *args, &block)
    @coeffenum.send(name, *args, &block)
  end

  # Forward respond_to? to the @coeffenum instance.
  def respond_to_missing?(name, incl_priv)
    @coeffenum.respond_to?(name, incl_priv)
  end

protected

  # Return reference to the underlying coefficient enumeration.
  def get_enum()
    @coeffenum
  end

private

  # Create a "const" lazy enumerator with the given n.
  # All elements are n.
  def make_const(n)
    Enumerator.new do |yielder|
      loop { yielder.yield(n) }
    end.lazy
  end

  # Create a "delta" lazy enumerator with the given n.
  # First element is n, then all subsequent elements are zero.
  def make_delta(n)
    Enumerator.new do |yielder|
      yielder.yield(n)
      loop { yielder.yield(0) }
    end.lazy
  end

  # Create an "iota" lazy enumerator with the given n.
  # Elements are consecutive integers, beginning with n.
  def make_iota(n)
    Enumerator.new do |yielder, i: n|
      loop { yielder.yield(i); i += 1 }
    end.lazy
  end

  # Create an "init" lazy enumerator with the given array.
  # Elements are the array elements, padded with zeroes.
  def make_init(array)
    Enumerator.new do |yielder, inx: -1|
      loop { yielder.yield((inx < (array.length - 1)) ? array[inx += 1] : 0) }
    end.lazy
  end

  # Convert a Numeric to an FPS instance, if needed.
  def convert(other)
    if other.kind_of?(Fps)
      other
    else
      if other.kind_of?(Numeric)
        Fps.new(delta: other)
      else
        raise TypeError 'non-numeric can\'t be converted to FPS type'
      end
    end
  end

end
