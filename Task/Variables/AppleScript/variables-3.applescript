on localx()
	set x to 0 -- implicit local
	return x
end localx

on globalx()
	set x to 0 -- implicit local
	return my x
end globalx

on run
	set x to 1 -- top-level implicit global
	return {localx(), globalx()}
end run
--> RETURNS: {0, 1}
