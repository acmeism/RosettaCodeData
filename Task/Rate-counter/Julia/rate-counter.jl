dosomething() = sleep(abs(randn()))

function runNsecondsworthofjobs(N)
    times = Vector{Float64}()
    totaltime = 0
    runcount = 0
    while totaltime < N
        t = @elapsed(dosomething())
        push!(times, t)
        totaltime += t
        runcount += 1
    end
    println("Ran job $runcount times, for total time of $totaltime seconds.")
    println("Average time per run was $(sum(times)/length(times)) seconds.")
    println("Individual times of the jobs in seconds were:")
    for t in times
        println("    $t")
    end
end

runNsecondsworthofjobs(5)
