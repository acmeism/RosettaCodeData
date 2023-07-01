Rot13(in)	New low,rot,up
	Set up="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	Set low="abcdefghijklmnopqrstuvwxyz"
	Set rot=$Extract(up,14,26)_$Extract(up,1,13)
	Set rot=rot_$Extract(low,14,26)_$Extract(low,1,13)
	Quit $Translate(in,up_low,rot)

Write $$Rot13("Hello World!") ; Uryyb Jbeyq!
Write $$Rot13("ABCDEFGHIJKLMNOPQRSTUVWXYZ") ; NOPQRSTUVWXYZABCDEFGHIJKLM
