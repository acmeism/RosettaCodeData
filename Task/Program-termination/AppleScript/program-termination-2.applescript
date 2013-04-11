on run
	f()
	display dialog "This message will never be displayed."
end run

on f()
	error
end f
