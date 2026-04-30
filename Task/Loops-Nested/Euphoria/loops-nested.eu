sequence a
a = rand(repeat(repeat(20, 10), 10))

integer wantExit
wantExit = 0

for i = 1 to 10 do
    for j = 1 to 10 do
	printf(1, "%g ", {a[i][j]})
	if a[i][j] = 20 then
	    wantExit = 1
	    exit
	end if
    end for
    if wantExit then
	exit
    end if
end for
