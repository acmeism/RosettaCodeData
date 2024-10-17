ccall(:jl_exit_on_sigint, Cvoid, (Cint,), 0)

function timeit()
    ticks = 0
    try
        while true
            sleep(0.5)
            ticks += 1
            println(ticks)
        end
    catch
    end
end

@time timeit()
println("Done.")
