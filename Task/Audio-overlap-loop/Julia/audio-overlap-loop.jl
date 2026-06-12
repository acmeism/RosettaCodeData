const soundfile = "loop.wav"

if length(ARGS) < 1
    println("Usage: give number of repetitions in echo effect as argument to the program.")
else
    ((repetitions = tryparse(Int, ARGS[1])) != nothing) || (repetitions = 3)
    (repetitions < 1) && (repetitions = 3)
    (repetitions > Threads.nthreads()) && (repetitions = Threads.nthreads())

    @Threads.threads for secs in 0.0:0.1:((repetitions - 1) * 0.1)
        begin sleep(secs); run(`play "$soundfile"`); end
    end
end
