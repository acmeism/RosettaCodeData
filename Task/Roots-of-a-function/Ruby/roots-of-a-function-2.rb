class Numeric
  def sign
    self <=> 0
  end
end

def find_roots(range, step = 1e-3)
  range.step( step ).inject( yield(range.begin).sign ) do |sign, x|
    value = yield(x)
    if value == 0
      puts "Root found at #{x}"
    elsif value.sign == -sign
      puts "Root found between #{x-step} and #{x}"
    end
    value.sign
  end
end

find_roots(-1..3) { |x| x**3 - 3*x**2 + 2*x }
