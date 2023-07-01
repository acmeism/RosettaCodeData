' Largest number divisible by its digits - base10 - VBScript
	s=7*8*9  	'reasonable assumption
	m=9876432   'reasonable assumption
	for i=(m\s)*s to 1 step -s
		if instr(i,"5")=0 and instr(i,"0")=0 then  '5 or 0 impossible
			b=false: j=1
			while j<=len(i)-1 and not b
				if instr(j+1,i,mid(i,j,1))<>0 then b=true  'no duplicated digit
				j=j+1
			wend
			if not b then
				j=1
				while j<=len(i) and not b
					if (i mod mid(i,j,1))<>0 then b=true  'divisible by all digits
					j=j+1
				wend
				if not b then exit for
			end if
		end if
	next
	wscript.echo i
