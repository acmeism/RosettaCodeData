DIGITS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

# convert a base 10 integer into a negative base value (as a string)

def negative_base_encode(n, b)
  raise 'base out of range' if (b < -62) || (b > -2)
  return '0' if n == 0
  revdigs = []
  while n != 0 do
    n, r = n.divmod(b)
    if r < 0
      n += 1
      r -= b
    end
    revdigs << r
  end
  return revdigs.reduce('') { |digstr, digit| DIGITS[digit] + digstr }
end

# convert a negative base value (as a string) into a base 10 integer

def negative_base_decode(n, b)
  raise 'base out of range' if (b < -62) || (b > -2)
  value = 0
  n.reverse.each_char.with_index do |ch, inx|
    value += DIGITS.index(ch) * b**inx
  end
  return value
end

# do the task

[ [10, -2], [146, -3], [15, -10], [0, -31], [-6221826, -62] ].each do |pair|
  decimal, base = pair
  encoded = negative_base_encode(decimal, base)
  decoded = negative_base_decode(encoded, base)
  puts("Enc: %8i base %-3i = %5s base %-3i  Dec: %5s base %-3i = %8i base %-3i" %
       [decimal, 10, encoded, base, encoded, base, decoded, 10])
end
