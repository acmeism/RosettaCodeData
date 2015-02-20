on callback for arg
	-- Returns a string like "arc has 3 letters"
	arg & " has " & (count arg) & " letters"
end callback

set alist to {"arc", "be", "circle"}
repeat with aref in alist
	-- Passes a reference to some item in alist
	-- to callback, then speaks the return value.
	say (callback for aref)
end repeat
