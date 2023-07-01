data =
(
127.0.0.1
127.0.0.1:80
::1
[::1]:80
2605:2700:0:3::4713:93e3
[2605:2700:0:3::4713:93e3]:80
)

output := ""
loop, parse, data, `n, `r
{
	x := ParseIP(A_LoopField)
	output .= "input = " A_LoopField "`t>`t" x.1 . (x.2 ? " port : " x.2 : "") "`n"
}
MsgBox % output
return
