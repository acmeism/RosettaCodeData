def sign(x)
  x <=> 0
end

def find_roots(f, range, step=0.001)
  sign = sign(f[range.begin])
  range.step(step) do |x|
    value = f[x]
    if value == 0
      puts "Root found at #{x}"
    elsif sign(value) == -sign
      puts "Root found between #{x-step} and #{x}"
    end
    sign = sign(value)
  end
end

f = lambda { |x| x**3 - 3*x**2 + 2*x }
find_roots(f, -1..3)
