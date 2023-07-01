puts
puts('FPS Creation:')
a = Fps.new(iota: 3)
puts("iota: a = #{a.first(10)}")
b = Fps.new(init: [12, 24, 36, 48])
puts("init: b = #{b.first(10)}")

puts
puts('FPS Arithmetic:')
puts("(a + b) = #{(a + b).first(10)}")
puts("(a - b) = #{(a - b).first(10)}")
puts("(a * b) = #{(a * b).first(10)}")
puts("(a / b) = #{(a / b).first(10)}")
puts("((a + b) - b) = #{((a + b) - b).first(10)}")
puts("((a / b) * b) = #{((a / b) * b).first(10)}")

puts
puts('FPS w/ Other Numerics:')
puts("(a + 3) = #{(a + 3).first(10)}")
puts("(a - 3) = #{(a - 3).first(10)}")
puts("(a * 3) = #{(a * 3).first(10)}")
puts("(a / 3) = #{(a / 3).first(10)}")
puts("(3 + a) = #{(3 + a).first(10)}")
puts("(3 - a) = #{(3 - a).first(10)}")
puts("(3 * a) = #{(3 * a).first(10)}")
puts("(3 / a) = #{(3 / a).first(10)}")
puts("(a + 4.4) = #{(a + 4.5).first(10)}")
puts("(a + Rational(11, 3)) = #{(a + Rational(11, 3)).first(10)}")
puts("(4.4 + a) = #{(4.5 + a).first(10)}")
puts("(Rational(11, 3) + a) = #{(Rational(11, 3) + a).first(10)}")

puts
puts('FPS Differentiation and Integration:')
puts("b.deriv = #{b.deriv.first(10)}")
puts("b.integ = #{b.integ.first(10)}")

puts
puts('Define sin(x) and cos(x) FPSs in terms of each other:')
fpssin = Fps.new
fpscos = 1 - fpssin.integ
fpssin.assign(fpscos.integ)
puts("fpssin = #{fpssin.first(10)}")
puts("fpscos = #{fpscos.first(10)}")

puts
puts('Display sin(x) and cos(x) FPSs as strings:')
puts("sin(x) = #{fpssin.to_s(10)}")
puts("cos(x) = #{fpscos.to_s(10)}")

puts
puts('Define tan(x) FPS as sin(x) / cos(x) from above:')
fpstan = fpssin / fpscos
puts("tan(x) = #{fpstan.to_s(10)}")

puts
puts('Compute sin^2(x)+cos^2(x) FPS from above:')
puts("sin^2(x)+cos^2(x) = #{((fpssin * fpssin) + (fpscos * fpscos)).to_s(5)}")

puts
puts('Define exp(x) in terms of its own integral:')
fpsexp = Fps.new
fpsexp.assign(1 + fpsexp.integ)
puts("exp(x) = #{fpsexp.to_s(10)}")

puts
puts('Evaluate the above at a few points using a few terms:')
puts("sin(0)    = #{fpssin.eval(0, 8).to_f}")
puts("cos(0)    = #{fpscos.eval(0, 8).to_f}")
puts("sin(pi/2) = #{fpssin.eval(Math::PI / 2, 16).to_f}")
puts("cos(pi/2) = #{fpscos.eval(Math::PI / 2, 16).to_f}")
puts("sin(pi)   = #{fpssin.eval(Math::PI, 16).to_f}")
puts("cos(pi)   = #{fpscos.eval(Math::PI, 16).to_f}")
puts("tan(0)    = #{fpstan.eval(0, 8).to_f}")
puts("exp(1)    = #{fpsexp.eval(1, 14).to_f}")
