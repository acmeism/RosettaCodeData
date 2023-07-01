# Generate Charmichael Numbers

require 'prime'

Prime.each(61) do |p|
  (2...p).each do |h3|
    g = h3 + p
    (1...g).each do |d|
      next if (g*(p-1)) % d != 0 or (-p*p) % h3 != d % h3
      q = 1 + ((p - 1) * g / d)
      next unless q.prime?
      r = 1 + (p * q / h3)
      next unless r.prime? and (q * r) % (p - 1) == 1
      puts "#{p} x #{q} x #{r}"
    end
  end
  puts
end
