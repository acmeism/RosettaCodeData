-- triangle.ads
generic
	type Dimension is private;
	Zero, Two: Dimension;
	with function "*"(Left, Right: in Dimension) return Dimension is <>;
	with function "/"(Left, Right: in Dimension) return Dimension is <>;
	with function "+"(Left, Right: in Dimension) return Dimension is <>;
	with function "-"(Left, Right: in Dimension) return Dimension is <>;
	with function ">"(Left, Right: in Dimension) return Boolean is <>;
	with function "="(Left, Right: in Dimension) return Boolean is <>;
	with function Image(D: in Dimension) return String is <>;
package Triangle is

	type Point is record
		X: Dimension;
		Y: Dimension;
	end record;

	type Triangle_T is record
		A,B,C: Point;
	end record;

	function Area(T: in Triangle_T) return Dimension;

	function IsPointInTriangle(P: Point; T: Triangle_T) return Boolean;

	function Image(P: Point) return String is
		("(X="&Image(P.X)&", Y="&Image(P.Y)&")")
		with Inline;

	function Image(T: Triangle_T) return String is
		("(A="&Image(T.A)&", B="&Image(T.B)&", C="&Image(T.C)&")")
		with Inline;
end;
