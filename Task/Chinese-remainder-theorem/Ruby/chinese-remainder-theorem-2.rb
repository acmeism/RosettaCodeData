def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Multiplicative inverse modulo does not exist!'
  end
  x % et
end

def chinese_remainder(mods, remainders)
  max = mods.inject( :* )  # product of all moduli
  series = remainders.zip(mods).map{ |r,m| (r * max * invmod(max/m, m) / m) }
  series.inject( :+ ) % max
end

p chinese_remainder([3,5,7], [2,3,2])     #=> 23
p chinese_remainder([17353461355013928499, 3882485124428619605195281, 13563122655762143587], [7631415079307304117, 1248561880341424820456626, 2756437267211517231]) #=> 937307771161836294247413550632295202816
p chinese_remainder([10,4,9], [11,22,19]) #=> nil
