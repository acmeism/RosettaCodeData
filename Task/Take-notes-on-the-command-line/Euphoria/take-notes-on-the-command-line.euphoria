constant cmd = command_line()
constant filename = "notes.txt"
integer fn
object line
sequence date_time

if length(cmd) < 3 then
    fn = open(filename,"r")
    if fn != -1 then
        while 1 do
            line = gets(fn)
            if atom(line) then
                exit
            end if
            puts(1,line)
        end while
        close(fn)
    end if
else
    fn = open(filename,"a") -- if such file doesn't exist it will be created
    date_time = date()
    date_time = date_time[1..6]
    date_time[1] += 1900
    printf(fn,"%d-%02d-%02d %d:%02d:%02d\n",date_time)
    line = "\t"
    for n = 3 to length(cmd) do
        line &= cmd[n] & ' '
    end for
    line[$] = '\n'
    puts(fn,line)
    close(fn)
end if
