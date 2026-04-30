'Bitmap/Bresenham's line algorithm - VBScript - 13/05/2019
	Dim map(48,40), list(10), ox, oy
	data=Array(1,8, 8,16, 16,8, 8,1, 1,8)
	For i=0 To UBound(map,1): For j=0 To UBound(map,2)
		map(i,j)="."
	Next: Next 'j, i
	points=(UBound(data)+1)/2
	For p=1 To points
		x=data((p-1)*2)
		y=data((p-1)*2+1)
		list(p)=Array(x,y)
		If p=1 Then minX=x: maxX=x: minY=y: maxY=y
		If x<minX Then minX=x
		If x>maxX Then maxX=x
		If y<minY Then minY=y
		If y>maxY Then maxY=y
	Next 'p
	border=2
	minX=minX-border*2  : maxX=maxX+border*2
	minY=minY-border    : maxY=maxY+border
	ox =-minX           : oy =-minY
	wx=UBound(map,1)-ox : If maxX>wx Then maxX=wx
	wy=UBound(map,2)-oy : If maxY>wy Then maxY=wy
	For x=minX To maxX: map(x+ox,0+oy)="-": Next 'x
	For y=minY To maxY: map(0+ox,y+oy)="|": Next 'y
	map(ox,oy)="+"
	For p=1 To points-1
		draw_line list(p), list(p+1)
	Next 'p
	For y=maxY To minY Step -1
		line=""
		For x=minX To maxX
			line=line & map(x+ox,y+oy)
		Next 'x
		Wscript.Echo line
	Next 'y

Sub draw_line(p1, p2)
	Dim x,y,xf,yf,dx,dy,sx,sy,err,err2
    x =p1(0)     : y =p1(1)
	xf=p2(0)     : yf=p2(1)
	dx=Abs(xf-x) : dy=Abs(yf-y)
	If x<xf Then sx=+1: Else sx=-1
	If y<yf Then sy=+1: Else sy=-1
	err=dx-dy
	Do
		map(x+ox,y+oy)="X"
		If x=xf And y=yf Then Exit Do
		err2=err+err
		If err2>-dy Then err=err-dy: x=x+sx
		If err2< dx Then err=err+dx: y=y+sy
	Loop
End Sub 'draw_line
