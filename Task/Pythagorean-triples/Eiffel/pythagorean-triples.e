class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	do
		Perimeter:= 100
		from
		until
			Perimeter>1000000
		loop
			pyt_tri(3,4,5)
			io.put_string ("There are " +total.out + " triples, below " + Perimeter.out + ". Of which " +  prim.out+ " are primitives.%N")
			Perimeter:= Perimeter*10
		end
	end

	pyt_tri(a, b, c: INTEGER)
	local
		p: INTEGER
	do
		p:= a+b+c
		if p<= Perimeter then
		prim:= prim+1
		total := total + Perimeter // p
		pyt_tri	(a+2*(-b+c), 2*(a+c)-b, 2*(a-b+c)+c)
		pyt_tri	(a+2*(b+c), 2*(a+c)+b, 2*(a+b+c)+c)
		pyt_tri	(-a+2*(b+c), 2*(-a+c)+b, 2*(-a+b+c)+c)
		end
	end
Perimeter:INTEGER
prim: INTEGER
total: INTEGER
end
