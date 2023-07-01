function dolongcomputation(cond)
    det(rand(4000, 4000))
    Base.notify(cond)
end

function printnotice(cond)
    Base.wait(cond)
    println("They are finished.")
end

function delegate()
    println("Starting task, sleeping...")
    condition = Base.Condition()
    Base.@async(printnotice(condition))
    Base.@async(dolongcomputation(condition))
end

delegate()
sleep(5)
println("Done sleeping.")
