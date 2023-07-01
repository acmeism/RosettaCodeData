' Combinations and permutations - vbs - 10/04/2017
dim i,j
Wscript.StdOut.WriteLine  "-- Long Integer - Permutations - from 1 to 12"
for i=1 to 12
	for j=1 to i
		Wscript.StdOut.Write "P(" & i & "," & j & ")=" & perm(i,j) & "  "
	next 'j
	Wscript.StdOut.WriteLine ""
next 'i
Wscript.StdOut.WriteLine  "-- Float integer - Combinations from 10 to 60"
for i=10 to 60 step 10
	for j=1 to i step i\5
		Wscript.StdOut.Write  "C(" & i & "," & j & ")=" & comb(i,j) & "  "
	next 'j
	Wscript.StdOut.WriteLine ""
next 'i
Wscript.StdOut.WriteLine  "-- Float integer - Permutations from 5000 to 15000"
for i=5000 to 15000 step 5000
	for j=10 to 70 step 20
		Wscript.StdOut.Write  "C(" & i & "," & j & ")=" & perm(i,j) & "  "
	next 'j
	Wscript.StdOut.WriteLine ""
next 'i
Wscript.StdOut.WriteLine  "-- Float integer - Combinations from 200 to 1000"
for i=200 to 1000 step 200
	for j=20 to 100 step 20
		Wscript.StdOut.Write "P(" & i & "," & j & ")=" & comb(i,j) & "  "
	next 'j
	Wscript.StdOut.WriteLine ""
next 'i

function perm(x,y)
	dim i,z
	z=1
	for i=x-y+1 to x
		z=z*i
	next 'i
	perm=z
end function 'perm
	
function fact(x)
	dim i,z
	z=1
	for i=2 to x
		z=z*i
	next 'i
	fact=z
end function 'fact

function comb(byval x,byval y)
	if y>x then
		comb=0
	elseif x=y then
		comb=1
	else
		if x-y<y then y=x-y
		comb=perm(x,y)/fact(y)
	end if
end function 'comb
