' Recaman's sequence - vbscript - 04/08/2015
	nx=15
	h=1000
	Wscript.StdOut.WriteLine "Recaman's sequence for the first " & nx & " numbers:"
	Wscript.StdOut.WriteLine recaman("seq",nx)
	Wscript.StdOut.WriteLine "The first duplicate number is: " & recaman("firstdup",0)
	Wscript.StdOut.WriteLine "The number of terms to complete the range 0--->"& h &" is: "& recaman("numterm",h)
	Wscript.StdOut.Write vbCrlf&".../...": zz=Wscript.StdIn.ReadLine()
	
function recaman(op,nn)
	Dim b,d,h
	Set b = CreateObject("Scripting.Dictionary")
	Set d = CreateObject("Scripting.Dictionary")
    list="0" : firstdup=0
	if op="firstdup" then
		nn=1000 : firstdup=1
	end if
	if op="numterm" then
		h=nn : nn=10000000 : numterm=1
	end if
	ax=0  'a(0)=0
	b.Add 0,1  'b(0)=1
	s=0
	for n=1 to nn-1
        an=ax-n
		if an<=0 then
			an=ax+n
		elseif b.Exists(an) then
			an=ax+n
		end if
		ax=an  'a(n)=an
		if not b.Exists(an) then b.Add an,1  'b(an)=1
		if op="seq" then
			list=list&" "&an
		end if
		if firstdup then
			if d.Exists(an) then
				recaman="a("&n&")="&an
				exit function
			else
				d.Add an,1  'd(an)=1
			end if
		end if
		if numterm then
			if an<=h then
				if not d.Exists(an) then
					s=s+1
					d.Add an,1  'd(an)=1
				end if
				if s>=h then
					recaman=n
					exit function
				end if
			end if
		end if
	next 'n
	recaman=list
end function 'recaman
