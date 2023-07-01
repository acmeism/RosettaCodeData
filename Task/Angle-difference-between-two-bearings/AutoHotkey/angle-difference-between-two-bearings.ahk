Angles:= [[20, 45]
        ,[-45, 45]
        ,[-85, 90]
        ,[-95, 90]
        ,[-45, 125]
        ,[-45, 145]
        ,[29.4803, -88.6381]
        ,[-78.3251, -159.036]
        ,[-70099.74233810938, 29840.67437876723]
        ,[-165313.6666297357, 33693.9894517456]
        ,[1174.8380510598456, -154146.66490124757]
        ,[60175.77306795546, 42213.07192354373]]

for i, set in angles
    result .= set.2 " to " set.1 " = " Angle_difference_between_two_bearings(set) "`n"
MsgBox, 262144, , % result
return

Angle_difference_between_two_bearings(set){
    return (diff := Mod(set.2, 360) - Mod(set.1, 360)) >180 ? diff-360 : diff
}
