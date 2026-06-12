def find_minmax_adjacent (number, ndigits)
  n = number[-ndigits..].to_u32
  min = max = n
  (number.size - ndigits - 1).downto(0) do |i|
    n = n // 10 + number[i].to_u32 * 10**(ndigits - 1)
    min = n if n < min
    max = n if n > max
  end
  { min, max }
end

number = Array.new(1000) { ('0'..'9').sample }.join
puts number
puts
puts "min: %05d, max: %05d" % find_minmax_adjacent(number, 5)
