# Extend class Integer with a string conveter.

class Integer
  def as_str()
    return to_s()
  end
end

# Extend class Complex with a string conveter (works only with Gaussian integers).

class Complex
  def as_str()
    return '0' if self == 0
    return real.to_i.to_s if imag == 0
    return imag.to_i.to_s + 'i' if real == 0
    return real.to_i.to_s + '+' + imag.to_i.to_s + 'i' if imag >= 0
    return real.to_i.to_s + '-' + (-(imag.to_i)).to_s + 'i'
  end
end

# Emit various tables of conversions.

1.step(16) do |gi|
  puts(" %4s -> %8s -> %4s     %4s -> %8s -> %4s" %
    [gi.as_str, base2i_encode(gi), base2i_decode(base2i_encode(gi)).as_str,
     (-gi).as_str, base2i_encode(-gi), base2i_decode(base2i_encode(-gi)).as_str])
end
puts
1.step(16) do |gi|
  gi *= 0+1i
  puts(" %4s -> %8s -> %4s     %4s -> %8s -> %4s" %
    [gi.as_str, base2i_encode(gi), base2i_decode(base2i_encode(gi)).as_str,
     (-gi).as_str, base2i_encode(-gi), base2i_decode(base2i_encode(-gi)).as_str])
end
puts
0.step(3) do |m|
  0.step(3) do |l|
    0.step(3) do |h|
      qi = (100 * h + 10 * m + l).to_s
      gi = base2i_decode(qi)
      md = base2i_encode(gi).match(/^(?<num>[0-3]+)(?:\.0)?$/)
      print(" %4s -> %6s -> %4s" % [qi, gi.as_str, md[:num]])
    end
    puts
  end
end
