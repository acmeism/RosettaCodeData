doors	new door,pass
	For door=1:1:100 Set door(door)=0
	For pass=1:1:100 For door=pass:pass:100 Set door(door)='door(door)
	For door=1:1:100 If door(door) Write !,"Door",$j(door,4)," is open"
	Write !,"All other doors are closed."
	Quit
Do doors
Door   1 is open
Door   4 is open
Door   9 is open
Door  16 is open
Door  25 is open
Door  36 is open
Door  49 is open
Door  64 is open
Door  81 is open
Door 100 is open
All other doors are closed.
