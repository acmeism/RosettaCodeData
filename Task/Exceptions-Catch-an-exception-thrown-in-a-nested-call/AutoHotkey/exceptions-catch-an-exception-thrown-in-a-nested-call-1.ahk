global U0 := Exception("First Exception")
global U1 := Exception("Second Exception")

foo()

foo(){
	try
		bar()
	catch e
		MsgBox % "An exception was raised: " e.Message
	bar()
}

bar(){
	baz()
}

baz(){
	static calls := 0
	if ( ++calls = 1 )
		throw U0
	else if ( calls = 2 )
		throw U1
}
