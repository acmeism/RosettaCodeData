const jobs = 12

mutable struct Environment
    seq::Int
    cnt::Int
    Environment() = new(0, 0)
end

const env = [Environment() for i in 1:jobs]
const currentjob = [1]

seq() = env[currentjob[1]].seq
cnt() = env[currentjob[1]].cnt
seq(n) = (env[currentjob[1]].seq = n)
cnt(n) = (env[currentjob[1]].cnt = n)

function hail()
    print(lpad(seq(), 4))
    if seq() == 1
        return
    end
    cnt(cnt() + 1)
    seq(isodd(seq()) ? 3 * seq() + 1 : div(seq(), 2))
end

function runtest()
    for i in 1:jobs
        currentjob[1] = i
        env[i].seq = i
    end
    computing = true
    while computing
        for i in 1:jobs
            currentjob[1] = i
            hail()
        end
        println()
        for j in 1:jobs
            currentjob[1] = j
            if seq() != 1
                break
            elseif j == jobs
                computing = false
            end
        end
    end
    println("\nCOUNTS:")
    for i in 1:jobs
        currentjob[1] = i
        print(lpad(cnt(), 4))
    end
    println()
end

runtest()
