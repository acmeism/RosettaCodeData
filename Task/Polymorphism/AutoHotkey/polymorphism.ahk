MyPoint := new Point(1, 8)
MyPoint.Print()
MyCircle := new Circle(4, 7, 9)
MyCircle2 := MyCircle.Copy()
MyCircle.SetX(2)	;Assignment method
MyCircle.y := 3		;Direct assignment
MyCircle.Print()
MyCircle2.Print()
MyCircle.SetX(100), MyCircle.SetY(1000), MyCircle.r := 10000
MsgBox, % MyCircle.__Class
	. "`n`nx:`t" MyCircle.GetX()
	. "`ny:`t" MyCircle.y
	. "`nr:`t" MyCircle.GetR()
return

class Point
{
	Copy()
	{
		return this.Clone()
	}
	GetX()
	{
		return this.x
	}
	GetY()
	{
		return this.y
	}
	__New(x, y)
	{
		this.x := x
		this.y := y
	}
	Print()
	{
		MsgBox, % this.__Class
			. "`n`nx:`t" this.x
			. "`ny:`t" this.y
	}
	SetX(aValue)
	{
		this.x := aValue
	}
	SetY(aValue)
	{
		this.y := aValue
	}
}

class Circle extends Point
{
	GetR()
	{
		return this.r
	}
	__New(x, y, r)
	{
		this.r := r
		base.__New(x, y)
	}
	Print()
	{
		MsgBox, % this.__Class
			. "`n`nx:`t" this.x
			. "`ny:`t" this.y
			. "`nr:`t" this.r
	}
	SetR(aValue)
	{
		this.r := aValue
	}
}
