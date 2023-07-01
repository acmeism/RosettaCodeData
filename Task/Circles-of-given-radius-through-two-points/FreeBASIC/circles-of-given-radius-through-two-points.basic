Type Point
    As Double x,y
    Declare Property length As Double
End Type

Property point.length As Double
Return Sqr(x*x+y*y)
End Property

Sub circles(p1 As Point,p2 As Point,radius As Double)
    Print "Points ";"("&p1.x;","&p1.y;"),("&p2.x;","&p2.y;")";", Rad ";radius
    Var ctr=Type<Point>((p1.x+p2.x)/2,(p1.y+p2.y)/2)
    Var half=Type<Point>(p1.x-ctr.x,p1.y-ctr.y)
    Var lenhalf=half.length
    If radius<lenhalf Then Print "Can't solve":Print:Exit Sub
    If lenhalf=0 Then Print "Points are the same":Print:Exit Sub
    Var dist=Sqr(radius^2-lenhalf^2)/lenhalf
    Var rot= Type<Point>(-dist*(p1.y-ctr.y) +ctr.x,dist*(p1.x-ctr.x) +ctr.y)
    Print " -> Circle 1 ("&rot.x;","&rot.y;")"
    rot= Type<Point>(-(rot.x-ctr.x) +ctr.x,-((rot.y-ctr.y)) +ctr.y)
    Print" -> Circle 2 ("&rot.x;","&rot.y;")"
    Print
End Sub


Dim As Point p1=(.1234,.9876),p2=(.8765,.2345)
circles(p1,p2,2)
p1=Type<Point>(0,2):p2=Type<Point>(0,0)
circles(p1,p2,1)
p1=Type<Point>(.1234,.9876):p2=p1
circles(p1,p2,2)
p1=Type<Point>(.1234,.9876):p2=Type<Point>(.8765,.2345)
circles(p1,p2,.5)
p1=Type<Point>(.1234,.9876):p2=p1
circles(p1,p2,0)

Sleep
