constant FREE = 0, LOCKED = 1
sequence forks
forks = repeat(FREE,5)

procedure person(sequence name, integer left_fork, integer right_fork)
    while 1 do
        while forks[left_fork] = LOCKED or forks[right_fork] = LOCKED do
            if forks[left_fork] = FREE then
                puts(1, name & " hasn't right fork.\n")
            elsif forks[right_fork] = FREE then
                puts(1, name & " hasn't left fork.\n")
            else
                puts(1, name & " hasn't both forks.\n")
            end if
            puts(1, name & " is waiting.\n")
            task_yield()
        end while

        puts(1, name & " grabs forks.\n")
        forks[left_fork] = LOCKED
        forks[right_fork] = LOCKED
        for i = 1 to rand(10) do
            puts(1, name & " is eating.\n")
            task_yield()
        end for
        puts(1, name & " puts forks down and leaves the dinning room.\n")
        forks[left_fork] = FREE
        forks[right_fork] = FREE

        for i = 1 to rand(10) do
            puts(1, name & " is thinking.\n")
            task_yield()
        end for
        puts(1, name & " becomes hungry.\n")
    end while
end procedure

integer rid
atom taskid
rid = routine_id("person")
taskid = task_create(rid,{"Aristotle",1,2})
task_schedule(taskid,{1,2})
taskid = task_create(rid,{"Kant",2,3})
task_schedule(taskid,{1,2})
taskid = task_create(rid,{"Spinoza",3,4})
task_schedule(taskid,{1,2})
taskid = task_create(rid,{"Marx",4,5})
task_schedule(taskid,{1,2})
taskid = task_create(rid,{"Russell",5,1})
task_schedule(taskid,{1,2})

while get_key() = -1 do
    task_yield()
end while
