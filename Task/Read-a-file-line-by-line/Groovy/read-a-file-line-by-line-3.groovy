procedure main()
f := open("input.txt","r") | stop("cannot open file ",fn)
while line := read(f)
close(f)
end
