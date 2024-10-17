require "complex"

def julia(c_real, c_imag)
  puts Complex.new(c_real, c_imag)
  -1.0.step(to: 1.0, by: 0.04) do |v|
    puts -1.4.step(to: 1.4, by: 0.02).map{|h| judge(c_real, c_imag, h, v)}.join
  end
end

def judge(c_real, c_imag, x, y)
  50.times do
    z_real = (x * x - y * y) + c_real
    z_imag = x * y * 2 + c_imag
    return " "  if z_real**2 > 10000
    x, y = z_real, z_imag
  end
  "#"
end

julia(-0.8, 0.156)
