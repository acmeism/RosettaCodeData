'mung.vbs
option explicit

sub mung(c)
	dim n
	n=c+1
	wscript.echo "[Level",n & "] Mung until no good"
	on error resume next
	mung n
	on error goto 0
	wscript.echo "[Level",n & "] no good"
end sub

mung 0
