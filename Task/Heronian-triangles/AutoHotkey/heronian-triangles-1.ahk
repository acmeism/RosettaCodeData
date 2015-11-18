Primitive_Heronian_triangles(MaxSide){
	obj :=[]
	loop, % MaxSide {
		a := A_Index
		loop % MaxSide-a+1 {
			b := A_Index+a-1
			loop % MaxSide-b+1 {
				c := A_Index+b-1, s := (a+b+c)/2, Area := Sqrt(s*(s-a)*(s-b)*(s-c))
				if (Area = Floor(Area)) && (Area>0) && !obj[a/s, b/s, c/s]
					obj[a/s, b/s, c/s]:=1 ,res .= (res?"`n":"") StrReplace(Area, ".000000") "`t" a+b+c "`t" a ", " b ", " c
	}	}	}
	Sort, res, F Sort
	return res
}

Sort(x, y){
	x := StrSplit(x, "`t"), y := StrSplit(y, "`t")
	return x.1 > y.1 ? 1 : x.1 < y.1 ? -1 : x.2 > y.2 ? 1 : x.2 < y.2 ? -1 : 0
}
