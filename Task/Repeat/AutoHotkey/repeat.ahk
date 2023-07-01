repeat("fMsgBox",3)
return

repeat(f, n){
	loop % n
		%f%()
}

fMsgBox(){
	MsgBox hello
}
