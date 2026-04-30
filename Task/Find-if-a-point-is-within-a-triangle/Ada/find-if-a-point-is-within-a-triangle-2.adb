-- triangle.adb

package body Triangle is
	function Area(T: in Triangle_T) return Dimension
	is
		tmp: Dimension;
	begin
		tmp:=((T.B.X*T.C.Y-T.C.X*T.B.Y)-(T.A.X*T.C.Y-T.C.X*T.A.Y)+(T.A.X*T.B.Y-T.B.X*T.A.Y))/Two;
		if tmp>Zero then
			return tmp;
		else
			return Zero-tmp;
		end if;
	end Area;

	function IsPointInTriangle(P: Point; T: Triangle_T) return Boolean
	is
	begin
		return Area(T)=Area((T.A,T.B,P))+Area((T.A,P,T.C))+Area((P,T.B,T.C));
	end IsPointInTriangle;
end;
