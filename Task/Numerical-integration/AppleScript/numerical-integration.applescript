script left_rect
	on call(f, x, h)
		f's call(x)
	end call
end script

script right_rect
	on call(f, x, h)
		f's call(x + h)
	end call
end script

script mid_rect
	on call(f, x, h)
		f's call(x + h / 2)
	end call
end script

script trapezium
	on call(f, x, h)
		((f's call(x)) + (f's call(x + h))) / 2
	end call
end script

script simpson
	on call(f, x, h)
		((f's call(x)) + 4 * (f's call(x + h / 2)) + (f's call(x + h))) / 6
	end call
end script

on integrate(f, a, b, n, rule)
	set h to (b - a) / n
	set res to 0
	repeat with i from 0 to n - 1
		set res to res + (rule's call(f, a + i * h, h))
	end repeat
	return h * res
end integrate

script cube
	on call(x)
		x ^ 3
	end call
end script

script reciprocal
	on call(x)
		1 / x
	end call
end script

script identity
	on call(x)
		x
	end call
end script

on integral_test(f, a, b, n)
	log "Integrating " & f's name & " from " & a & " to " & b & " with " & n & " steps..."
	set rules to {left_rect, right_rect, mid_rect, trapezium, simpson}
	repeat with rule in rules
		log "Rule: " & rule's name
		log integrate(f, a, b, n, rule)
	end repeat
end integral_test

integral_test(cube, 0, 1, 100)
integral_test(reciprocal, 1, 100, 1000)
integral_test(identity, 0, 5000, 5000000)
integral_test(identity, 0, 6000, 6000000)
