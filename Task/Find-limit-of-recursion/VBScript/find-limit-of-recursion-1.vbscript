'mung.vbs
option explicit

dim c
if wscript.arguments.count = 1 then
	c = wscript.arguments(0)
	c = c + 1
else
	c = 0
end if
wscript.echo "[Depth",c & "] Mung until no good."
CreateObject("WScript.Shell").Run "cscript Mung.vbs " & c, 1, true
wscript.echo "[Depth",c & "] no good."
