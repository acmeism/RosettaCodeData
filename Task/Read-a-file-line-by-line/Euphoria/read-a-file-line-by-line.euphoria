constant cmd = command_line()
constant filename = cmd[2]
constant fn = open(filename,"r")
integer i
i = 1
object x
while 1 do
    x = gets(fn)
    if atom(x) then
        exit
    end if
    printf(1,"%2d: %s",{i,x})
    i += 1
end while
close(fn)
