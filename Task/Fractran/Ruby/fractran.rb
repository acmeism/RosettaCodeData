str = %w[17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1]
FractalProgram = str.map(&:to_r)                                #=> array of rationals

Runner = Enumerator.new do |y|
  num = 2
  loop{ y << num *= FractalProgram.detect{|f| (num*f).denominator == 1} }
end

prime_generator = Enumerator.new do |y|
  Runner.each do |num|
    l = Math.log2(num)
    y << l.to_i if l.floor == l
  end
end

# demo
p Runner.take(20).map(&:numerator)
p prime_generator.take(20)
