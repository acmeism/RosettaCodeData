-- Compose two functions, where each function is
-- a script object with a call(x) handler.
on compose(f, g)
	script
		on call(x)
			f's call(g's call(x))
		end call
	end script
end compose

script increment
	on call(n)
		n + 1
	end call
end script

script decrement
	on call(n)
		n - 1
	end call
end script

script twice
	on call(x)
		x * 2
	end call
end script

script half
	on call(x)
		x / 2
	end call
end script

script cube
	on call(x)
		x ^ 3
	end call
end script

script cuberoot
	on call(x)
		x ^ (1 / 3)
	end call
end script

set functions to {increment, twice, cube}
set inverses to {decrement, half, cuberoot}
set answers to {}
repeat with i from 1 to 3
	set end of answers to ¬
		compose(item i of inverses, ¬
			item i of functions)'s ¬
		call(0.5)
end repeat
answers -- Result: {0.5, 0.5, 0.5}
