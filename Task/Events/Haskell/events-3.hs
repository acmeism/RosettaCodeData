record Event(cond, value)

procedure main()
    event := Event(condvar())
    t1 := thread {
        write("Task one waiting for event....")
        critical event.cond: while /(event.value) do wait(event.cond)
        write("Task one received event.")
        }
    t2 := thread {
        write("Task two waiting for event....")
        critical event.cond: while /(event.value) do wait(event.cond)
        write("Task two received event.")
        }
    delay(1000)                   # Let main thread post the event.
    event.value := "yes"
    write("Signalling event.")
    signal(event.cond,0)
    every wait(t1|t2)
end
