function acquire(num, sem)
    sleep(rand())
    println("Task $num waiting for semaphore")
    lock(sem)
    println("Task $num has acquired semaphore")
    sleep(rand())
    unlock(sem)
end


function runsem(numtasks)
    println("Sleeping and running $numtasks tasks.")
    sem = Base.Threads.RecursiveSpinLock()
    @sync(
    for i in 1:numtasks
        @async acquire(i, sem)
    end)
    println("Done.")
end

runsem(4)
