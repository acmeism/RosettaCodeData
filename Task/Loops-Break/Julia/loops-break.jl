while true
    n = rand(0:19)
    @printf "%4d" n
    if n == 10
        println()
        break
    end
    n = rand(0:19)
    @printf "%4d\n" n
end
