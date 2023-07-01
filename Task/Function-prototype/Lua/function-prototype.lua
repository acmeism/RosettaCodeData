function Func() -- Does not require arguments
	return 1
end

function Func(a,b) -- Requires arguments
	return a + b
end

function Func(a,b) -- Arguments are optional
	return a or 4 + b or 2
end

function Func(a,...) -- One argument followed by varargs
	return a,{...} -- Returns both arguments, varargs as table
end
