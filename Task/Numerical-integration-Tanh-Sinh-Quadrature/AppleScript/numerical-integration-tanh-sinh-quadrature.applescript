on jsmath(x, fname)
	run script "Math." & fname & "(" & x & ")" in "JavaScript"
end jsmath

script sin
	on call(x)
		jsmath(x, "sin")
	end call
end script

script exp
	on call(x)
		jsmath(x, "exp")
	end call
end script

on tanhsinh(f, lower, upper, steps, acc)
	set h to 0.1
	set h0 to (upper - lower) / 2
	set h1 to (upper + lower) / 2
	set rr to 0
	repeat with k from 1 to steps
		set ro to rr
		set n to 2 ^ k - 1
		set ss to 0
		repeat with i from -n to n
			set t to i * h
			set sh to jsmath(t, "sinh")
			set ch to jsmath(t, "cosh")
			set thh to jsmath(sh * pi / 2, "tanh")
			set dx to (ch * pi / 2) / (jsmath(sh * pi / 2, "cosh") ^ 2)
			set xi to h1 + h0 * thh
			set wt to h * dx
			set ss to ss + (f's call(xi)) * wt
		end repeat
		set rr to h0 * ss
		if jsmath(rr - ro, "abs") < acc then exit repeat
	end repeat
	return rr
end tanhsinh

log tanhsinh(sin, 0, 1, 5, 10 ^ -8)
log tanhsinh(exp, -3, 3, 5, 10 ^ -8)
