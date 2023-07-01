'ASCII Julia set. Translated from lua. Run with CScript
'Console should be 135x50 to avoid wrapping and scroll
sub pause() wscript.stdout.write  "Press Enter to Continue":wscript.stdin.readline: end sub
cmap=array(" ", ".", ":", "-", "=", "+", "*", "#", "%", "$", "@" )
for y = -1.0 to 1.0 step 0.05
  for x = -1.5 to 1.5 step 0.025
    zr=x
		zi=y
		i=0
    do while i < 100
       zr1 = zr*zr - zi*zi - 0.79
			 zi=zr * zi * 2 + 0.15
			 zr=zr1
      if (zr*zr + zi*zi) > 4. then exit do
			i = i + 1
    loop
    wscript.stdout.write cmap(i\10)
  next
	wscript.stdout.write vbcrlf
Next
pause
