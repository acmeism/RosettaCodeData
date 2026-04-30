integer in,out
object line

in = open("input.txt","r")
out = open("output.txt","w")

while 1 do
    line = gets(in)
    if atom(line) then -- EOF reached
        exit
    end if
    puts(out,line)
end while

close(out)
close(in)
