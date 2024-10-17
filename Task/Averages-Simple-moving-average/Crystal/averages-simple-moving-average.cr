def sma(n) Proc(Float64, Float64)
	a = Array(Float64).new
	->(x : Float64) {
		a.shift if a.size == n
		a.push x
		a.sum / a.size.to_f
	}
end

sma3, sma5 = sma(3), sma(5)

# Copied from the Ruby solution.
(1.upto(5).to_a + 5.downto(1).to_a).each do |n|
	printf "%d: sma3 = %.3f - sma5 = %.3f\n", n, sma3.call(n.to_f), sma5.call(n.to_f)
end
