dim amb
set amb = new ambiguous

amb.rule = "right(p1,1)=left(p2,1)"

dim w1, w2, w3, w4
for each w1 in split("the that a", " ")
	for each w2 in split("frog elephant thing", " ")
		for each w3 in split("walked treaded grows", " ")
			for each w4 in split("slowly quickly", " ")
				if amb(w1, w2) and amb(w2, w3) and amb(w3, w4) then
					wscript.echo w1, w2, w3, w4
				end if
			next
		next
	next
next
