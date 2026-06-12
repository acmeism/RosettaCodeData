const program = """
    outfile = "test_daemon_output.log"
    redirect_stdio(; stdin = devnull, stdout = open(outfile, "w"), stderr = devnull)
    first_t = time()
    while time() < first_t + 20
        println("timer running, \$(time() - first_t) seconds")
        sleep(1)
    end
"""
const daemon_cmd = `julia -e $program`

@async run(detach(daemon_cmd))
