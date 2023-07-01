class generator
	dim t1
	dim t2
	dim tn
	dim cur_overflow
	
	Private Sub Class_Initialize
		cur_overflow = false
		t1 = ccur(0)
		t2 = ccur(1)
		tn = ccur(t1 + t2)
	end sub
	
	public default property get generated
		on error resume next

		generated = ccur(tn)
		if err.number <> 0 then
			generated = cdbl(tn)
			cur_overflow = true
		end if
		t1 = ccur(t2)
		if err.number <> 0 then
			t1 = cdbl(t2)
			cur_overflow = true
		end if
		t2 = ccur(tn)
		if err.number <> 0 then
			t2 = cdbl(tn)
			cur_overflow = true
		end if
		tn = ccur(t1+ t2)
		if err.number <> 0 then
			tn = cdbl(t1) + cdbl(t2)
			cur_overflow = true
		end if
		on error goto 0
	end property
	
	public property get overflow
		overflow = cur_overflow
	end property
		
end class
