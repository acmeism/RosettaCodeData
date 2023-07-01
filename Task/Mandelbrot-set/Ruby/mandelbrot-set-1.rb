require 'complex'

def mandelbrot(a)
  Array.new(50).inject(0) { |z,c| z*z + a }
end

(1.0).step(-1,-0.05) do |y|
  (-2.0).step(0.5,0.0315) do |x|
    print mandelbrot(Complex(x,y)).abs < 2 ? '*' : ' '
  end
  puts
end
