sequence lines
sequence count
lines = {}
count = {}

procedure read(integer fn)
    object line
    while 1 do
        line = gets(fn)
        if atom(line) then
            exit
        else
            lines = append(lines, line)
            task_yield()
        end if
    end while

    lines = append(lines,0)
    while length(count) = 0 do
        task_yield()
    end while

    printf(1,"Count: %d\n",count[1])
end procedure

procedure write(integer fn)
    integer n
    object line
    n = 0
    while 1 do
        while length(lines) = 0 do
            task_yield()
        end while

        line = lines[1]
        lines = lines[2..$]
        if atom(line) then
            exit
        else
            puts(fn,line)
            n += 1
        end if
    end while
    count = append(count,n)
end procedure

integer fn
atom reader, writer
constant stdout = 1
fn = open("input.txt","r")
reader = task_create(routine_id("read"),{fn})
writer = task_create(routine_id("write"),{stdout})
task_schedule(writer,1)
task_schedule(reader,1)

while length(task_list()) > 1 do
    task_yield()
end while
