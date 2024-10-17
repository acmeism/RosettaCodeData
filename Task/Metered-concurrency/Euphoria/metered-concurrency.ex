sequence sems
sems = {}
constant COUNTER = 1, QUEUE = 2

function semaphore(integer n)
    if n > 0 then
        sems = append(sems,{n,{}})
        return length(sems)
    else
        return 0
    end if
end function

procedure acquire(integer id)
    if sems[id][COUNTER] = 0 then
        task_suspend(task_self())
        sems[id][QUEUE] &= task_self()
        task_yield()
    end if
    sems[id][COUNTER] -= 1
end procedure

procedure release(integer id)
    sems[id][COUNTER] += 1
    if length(sems[id][QUEUE])>0 then
        task_schedule(sems[id][QUEUE][1],1)
        sems[id][QUEUE] = sems[id][QUEUE][2..$]
    end if
end procedure

function count(integer id)
    return sems[id][COUNTER]
end function

procedure delay(atom delaytime)
    atom t
    t = time()
    while time() - t < delaytime do
        task_yield()
    end while
end procedure

integer sem

procedure worker()
    acquire(sem)
        printf(1,"- Task %d acquired semaphore.\n",task_self())
        delay(2)
    release(sem)
    printf(1,"+ Task %d released semaphore.\n",task_self())
end procedure

integer task

sem = semaphore(4)

for i = 1 to 10 do
    task = task_create(routine_id("worker"),{})
    task_schedule(task,1)
    task_yield()
end for

while length(task_list())>1 do
    task_yield()
end while
