include std/math.e

integer order = 4

function InCarpet(atom x, atom y)
	while 1 do
		if x = 0 or y = 0 then
			return 1
		elsif floor(mod(x,3)) = 1 and floor(mod(y,3)) = 1 then
			return 0
		end if
		x /= 3
		y /= 3
	end while
end function

for i = 0 to power(3,order)-1 do
	for j = 0 to power(3,order)-1 do
		if InCarpet(i,j) = 1 then
			puts(1,"#")
		else
			puts(1," ")
		end if
	end for
	puts(1,'\n')
end for
