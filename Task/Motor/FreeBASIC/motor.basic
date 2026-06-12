Type Vec4Flt
    x As Single
    y As Single
    z As Single
    w As Single
End Type

Type Vec8Flt
    As Single dato(0 To 7)
End Type

Type quat_flt As Vec4Flt
Type rotor As quat_flt
Type screw As quat_flt
Type motor As Vec8Flt

#macro motor_rotor(motor_)
    Cptr(rotor Ptr, @motor_)
#endmacro

#macro motor_screw(motor_)
    Cptr(screw Ptr, Cptr(Any Ptr, @motor_) + 16)  ' 4*Single = 16 bytes
#endmacro

' Example
Dim m As motor => { _
( 1.0, 0.0, 0.0, 0.0 ), _ ' rotor
( 0.0, 1.0, 0.0, 0.0 ) }  ' screw

Print (*r).x  ' 1.0
Print (*s).x  ' 0.0 (screw x)

(*r).x = 2.0
Print m.dato(0)  ' now 2.0

Sleep
