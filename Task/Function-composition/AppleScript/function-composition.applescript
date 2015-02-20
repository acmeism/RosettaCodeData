-- Compose two functions where each function is
-- a script object with a call(x) handler.
on compose(f, g)
	script
		on call(x)
			f's call(g's call(x))
		end call
	end script
end compose

script sqrt
	on call(x)
		x ^ 0.5
	end call
end script

script twice
	on call(x)
		2 * x
	end call
end script

compose(sqrt, twice)'s call(32)
-- Result: 8.0
