on accumulator(n)
	-- Returns a new script object
	-- containing a handler.
	script
		on call(i)
			set n to n + i -- Returns n.
		end call
	end script
end accumulator

set x to accumulator(10)
log x's call(1)
set y to accumulator(5)
log y's call(2)
log x's call(3.5)
-- Event Log: (*11*) (*7*) (*14.5*)
