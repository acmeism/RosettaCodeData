padovan = Enumerator.new do |y|
  ar = [1, 1, 1]
  loop do
    ar << ar.first(2).sum
    y  << ar.shift
  end
end

P, S = 1.324717957244746025960908854, 1.0453567932525329623
def padovan_f(n) = (P**(n-1) / S + 0.5).floor

puts "Recurrence Padovan: #{padovan.take(20)}"
puts "Floor function:     #{(0...20).map{|n| padovan_f(n)}}"

n = 63
bool =  (0...n).map{|n| padovan_f(n)} == padovan.take(n)
puts "Recurrence and floor function are equal upto #{n}: #{bool}."
puts

def l_system(axiom = "A", rules = {"A" => "B", "B" => "C", "C" => "AB"} )
  return enum_for(__method__,  axiom, rules) unless block_given?
  loop do
    yield axiom
    axiom = axiom.chars.map{|c| rules[c] }.join
  end
end

puts "First 10 elements of L-system: #{l_system.take(10).join(", ")} "
n = 32
bool = l_system.take(n).map(&:size) == padovan.take(n)
puts "Sizes of first #{n} l_system strings equal to recurrence padovan? #{bool}."
