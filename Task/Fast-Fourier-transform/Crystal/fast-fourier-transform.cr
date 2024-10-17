require "complex"

def fft(x : Array(Int32 | Float64)) #: Array(Complex)
  return [x[0].to_c] if x.size <= 1
  even = fft(Array.new(x.size // 2) { |k| x[2 * k] })
  odd  = fft(Array.new(x.size // 2) { |k| x[2 * k + 1] })
  c = Array.new(x.size // 2) { |k| Math.exp((-2 * Math::PI * k / x.size).i) }
  codd = Array.new(x.size // 2) { |k| c[k] * odd[k] }
  return Array.new(x.size // 2) { |k| even[k] + codd[k] } + Array.new(x.size // 2) { |k| even[k] - codd[k] }
end

fft([1,1,1,1,0,0,0,0]).each{ |c| puts c }
