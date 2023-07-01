methods =
(
load, spin, load, spin, fire, spin, fire
load, spin, load, spin, fire, fire
load, load, spin, fire, spin, fire
load, load, spin, fire, fire
)

for i, method in StrSplit(methods, "`n", "`r"){
	death := 0
	main:
	loop 100000	{
		sixGun := []
		for i, v in StrSplit(StrReplace(method," "), ",")
			if %v%()
				continue, main
	}
	output .= Format("{1:0.3f}", death/1000) "% Deaths for : """ method """`n"
}
MsgBox % output
return

load(){
	global
	if !sixGun.Count()
		sixGun := [0,1,0,0,0,0]
	else
		if sixGun[2]
			sixGun[1] := 1
	sixGun[2] := 1
}
fire(){
	global
	if bullet := sixGun[1]
		death++
	temp := sixGun[6]
	loop, 5
		sixGun[7-A_Index] := sixGun[6-A_Index]
	sixGun[1] := temp
	return bullet
}
spin(){
	global
	Random, rnd, 1, 12
	loop, % rnd	{
		temp := sixGun[6]
		loop, 5
			sixGun[7-A_Index] := sixGun[6-A_Index]
		sixGun[1] := temp
	}
}
