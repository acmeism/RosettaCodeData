import Base.print

struct Action{T}
    f::Function
    i::T
end

struct ActionOutcome{T}
    act::Action{T}
    out::T
end

Base.print(io::IO, ao::ActionOutcome) = print(io, "$(ao.act.f) $(ao.act.i) yields $(ao.out)")

memoized = Dict{Int, Int}()

function findshortest(start, goal, fails, actions, verbose=true, maxsteps=100000)
    solutions, numsteps = Vector{Vector{ActionOutcome}}(), 0
    seqs = [ActionOutcome[ActionOutcome(Action(div, 0), start)]]
    if start == goal
        verbose && println("For start of $start, no steps needed.\n")
        return 0
    end
    while numsteps < maxsteps && isempty(solutions)
        newsequences = Vector{Vector{ActionOutcome}}()
        numsteps += 1
        for seq in seqs
            for (act, arr) in actions, x in arr
                result = act(seq[end].out, x)
                if !fails(result)
                    newactionseq = vcat(seq, ActionOutcome(Action(act, x), result))
                    numsteps == 1 && popfirst!(newactionseq)
                    if result == goal
                        push!(solutions, newactionseq)
                    else
                        push!(newsequences, newactionseq)
                    end
                end
            end
            if !verbose && isempty(solutions) &&
                           all(x -> haskey(memoized, x[end].out), newsequences)
                minresult = minimum(x -> memoized[x[end].out], newsequences) + numsteps
                memoized[start] = minresult
                return minresult
            end
        end
        seqs = newsequences
    end
    if verbose
        l = length(solutions)
        print("There ", l > 1 ? "are $l solutions" : "is $l solution",
            " for path of length ", numsteps, " from $start to $goal.\nExample: ")
        for step in solutions[1]
            print(step, step.out == 1 ? "\n\n" : ", ")
        end
    end
    memoized[start] = numsteps
    return numsteps
end

failed(n) = n < 1

const divisors = [2, 3]
divide(n, x) = begin q, r = divrem(n, x); r == 0 ? q : -1 end

const subtractors1, subtractors2 = [1], [2]
subtract(n, x) = n - x

actions1 = Dict(divide => divisors, subtract => subtractors1)
actions2 = Dict(divide => divisors, subtract => subtractors2)

function findmaxshortest(g, fails, acts, maxn)
    stepcounts = [findshortest(n, g, fails, acts, false) for n in 1:maxn]
    maxs = maximum(stepcounts)
    maxstepnums = findall(x -> x == maxs, stepcounts)
    println("There are $(length(maxstepnums)) with $maxs steps for start between 1 and $maxn: ", maxstepnums)
end

function teststeps(g, fails, acts, maxes)
    println("\nWith goal $g, divisors $(acts[divide]), subtractors $(acts[subtract]):")
    for n in 1:10
        findshortest(n, g, fails, acts)
    end
    for maxn in maxes
        findmaxshortest(g, fails, acts, maxn)
    end
end

teststeps(1, failed, actions1, [2000, 20000, 50000])
empty!(memoized)
teststeps(1, failed, actions2, [2000, 20000, 50000])
