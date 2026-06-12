MsgBox % result := arcLength(10, 10, 120)
return

arcLength(radius, angle1, angle2){
    return (360 - Abs(angle2-angle1)) * (π := 3.141592653589793) * radius / 180
}
