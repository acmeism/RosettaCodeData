testAngles := [-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000]

result .= "Degrees    Degrees    Gradians    Mils    Radians`n"
for i, a in testAngles
    result .= a "`t" Deg2Deg(a) "`t" Deg2Grad(a) "`t" Deg2Mil(a) "`t" Deg2Rad(a) "`n"
result .= "`nGradians    Degrees    Gradians    Mils    Radians`n"
for i, a in testAngles
    result .= a "`t" Grad2Deg(a) "`t" Grad2Grad(a) "`t" Grad2Mil(a) "`t" Grad2Rad(a) "`n"
result .= "`nMills    Degrees    Gradians    Mils    Radians`n"
for i, a in testAngles
    result .= a "`t" Mil2Deg(a) "`t" Mil2Grad(a) "`t" Mil2Mil(a) "`t" Mil2Rad(a) "`n"
result .= "`nRadians    Degrees    Gradians    Mils    Radians`n"
for i, a in testAngles
    result .= a "`t" Rad2Deg(a) "`t" Rad2Grad(a) "`t" Rad2Mil(a) "`t" Rad2Rad(a) "`n"

MsgBox, 262144, , % result
return
;-------------------------------------------------------
Deg2Deg(Deg){
    return Mod(Deg, 360)
}
Deg2Grad(Deg){
    return Deg2Deg(Deg) * 400 / 360
}
Deg2Mil(Deg){
    return Deg2Deg(Deg) * 6400 / 360
}
Deg2Rad(Deg){
    return Deg2Deg(Deg) * (π:=3.141592653589793) / 180
}
;-------------------------------------------------------
Grad2Grad(Grad){
    return Mod(Grad, 400)
}
Grad2Deg(Grad){
    return Grad2Grad(Grad) * 360 / 400
}
Grad2Mil(Grad){
    return Grad2Grad(Grad) * 6400 / 400
}
Grad2Rad(Grad){
    return Grad2Grad(Grad) * (π:=3.141592653589793) / 200
}
;-------------------------------------------------------
Mil2Mil(Mil){
    return Mod(Mil, 6400)
}
Mil2Deg(Mil){
    return Mil2Mil(Mil) * 360 / 6400
}
Mil2Grad(Mil){
    return Mil2Mil(Mil) * 400 / 6400
}
Mil2Rad(Mil){
    return Mil2Mil(Mil) * (π:=3.141592653589793) / 3200
}
;-------------------------------------------------------
Rad2Rad(Rad){
    return Mod(Rad, 2*(π:=3.141592653589793))
}
Rad2Deg(Rad){
    return Rad2Rad(Rad) * 180 / (π:=3.141592653589793)
}
Rad2Grad(Rad){
    return Rad2Rad(Rad) * 200 / (π:=3.141592653589793)
}
Rad2Mil(Rad){
    return Rad2Rad(Rad) * 3200 / (π:=3.141592653589793)
}
;-------------------------------------------------------
