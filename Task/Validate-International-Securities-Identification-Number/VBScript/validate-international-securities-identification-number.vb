' Validate International Securities Identification Number - 03/03/2019

buf=buf&test("US0378331005")&vbCrLf
buf=buf&test("US0373831005")&vbCrLf
buf=buf&test("U50378331005")&vbCrLf
buf=buf&test("US03378331005")&vbCrLf
buf=buf&test("AU0000XVGZA3")&vbCrLf
buf=buf&test("AU0000VXGZA3")&vbCrLf
buf=buf&test("FR0000988040")&vbCrLf
msgbox buf,,"Validate International Securities Identification Number"

function test(cc)
	dim err,c,r,s,i1,i2
	if len(cc)=12 then
		for i=1 to len(cc)
			p=instr("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",mid(cc,i,1))
			if p<>0 then c=c&(p-1) else err=1
		next 'i
		for i=1 to 2
			if instr("ABCDEFGHIJKLMNOPQRSTUVWXYZ",mid(cc,i,1))=0 then err=1
		next 'i
		if err=0 then
			for i=len(c) to 1 step -1
				r=r&mid(c,i,1)
			next 'i
			for i=1 to len(r) step 2
				i1=i1+cint(mid(r,i,1))
			next 'i
			for i=2 to len(r) step 2
				ii=cint(mid(r,i,1))*2
				if ii>=10 then ii=ii-9
				i2=i2+ii
			next 'i
			s=cstr(i1+i2)
			if mid(s,len(s),1)="0" then
				msg="valid"
			else
				msg="invalid ??1"
			end if
		else
			msg="invalid ??2"
		end if
	else
		msg="invalid ??3"
	end if
	test=cc&" "&msg
end function 'test
