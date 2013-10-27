#floyd(n) creates an n-row floyd's triangle counting from 1 to (n/2+.5)*n
function floyd(n)
	x = 1
	dig(x,line,n) = (while line < n; x+=line; line+= 1 end; return ndigits(x)+1)
	for line = 1:n, i = 1:line; print(lpad(x,dig(x,line,n)," ")); x+=1; i==line && print("\n") end
end
