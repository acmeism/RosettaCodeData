-- test_triangle.adb
with Ada.Text_IO;
use Ada.Text_IO;
with Triangle;

procedure test_triangle
is
	package affine_tri is new Triangle(Dimension=>Integer, Zero=>0,Two=>2, Image=>Integer'Image);
	use affine_tri;
	tri1: Triangle_T:=((1,0),(2,0),(0,2));
	tri2: Triangle_T:=((-1,0),(-1,-1),(2,2));
	origin: Point:=(0,0);
begin
	Put_Line("IsPointInTriangle("&Image(origin)&", "&Image(tri1)&") yields "&IsPointInTriangle(origin,tri1)'Image);
	Put_Line("IsPointInTriangle("&Image(origin)&", "&Image(tri2)&") yields "&IsPointInTriangle(origin,tri2)'Image);
end test_triangle;
