using ThreadSafeDicts  # implement a single lock on all thread's shared values as a lockable Dict (keyed by a process id)

const dict = ThreadSafeDict()
flag(id) = get(dict, id, 0)

const criticalvalue = [1]

""" test the implementation on each thread, concurrently"""
function runSzymański(id, allszy)
    others = filter(!=(id), allszy)
    dict[id] = 1                              # Standing outside waiting room
    while !all(t -> flag(t) < 3, others)      # Wait for open door
        yield()
    end
    dict[id] = 3                                     # Standing in doorway
    if any(t -> flag(t) == 1, others)         # Another process is waiting to enter
        dict[id] = 2                          # Waiting for other processes to enter
        while !any(t -> flag(t) == 4, others) # Wait for a process to enter and close the door
            yield()
        end
    end
    dict[id] = 4                              # The door is closed
    for t in others                           # Wait for everyone of lower ID to finish exit
        t >= id && continue
        while flag(t) > 1
            yield()
        end
    end

    # critical section
    criticalvalue[1] += id * 3
    criticalvalue[1] ÷= 2
    println("Thread ", id, " changed the critical value to $(criticalvalue[1]).")
    # end critical section

    # Exit protocol
    for t in others                           # Ensure everyone in the waiting room has
        t <= id && continue
        while flag(t) ∉ [0, 1, 4]             # realized that the door is supposed to be closed

            yield()
        end
    end
    dict[id] = 0                              # Leave. Reopen door if nobody is still in the waiting room
end

function test_Szymański(N)
    allszy = collect(1:N)
    @Threads.threads for i in eachindex(allszy)
        runSzymański(i, allszy)
    end
end

test_Szymański(20)
