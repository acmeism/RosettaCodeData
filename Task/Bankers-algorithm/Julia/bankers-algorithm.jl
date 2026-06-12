function queryprompt(query, typ)
    print(query, ": ")
    entry = uppercase(strip(readline(stdin)))
    return (typ <: Integer) ? parse(Int, entry) :
        (typ <: Vector) ? map(x -> parse(Int, x), split(entry, r"\s+")) :
        entry
end

function testbankers()
    r = queryprompt("Enter the number of resources", Int)
    p = queryprompt("\nEnter the number of processes", Int)
    maxres = queryprompt("\nEnter Claim Vector", Vector{Int})
    curr, maxclaim = zeros(Int, p, r), zeros(Int, p, r)

    for i in 1:p
        curr[i, :] .= queryprompt("\nEnter Allocated Resource Table, Row $i", Vector{Int})
    end
     for i in 1:p
        maxclaim[i, :] .= queryprompt("\nEnter Maximum Claim Table, Row $i", Vector{Int})
    end

    alloc = [sum(curr[:, j]) for j in 1:r]
    println("\nAllocated Resources: $alloc")

    avl = map(i -> maxres[i] - alloc[i], 1:r)
    println("\nAvailable Resources: $avl")

    running = trues(p)
    count = p
    while count != 0
        safe = false
        for i in 1:p
            if running[i]
                exec = true
                for j in 1:r
                    if maxclaim[i, j] - curr[i, j] > avl[j]
                        exec = false
                        break
                    end
                end

                if exec
                    println("\nProcess $i is executing.")
                    running[i] = false
                    count -= 1
                    safe = true
                    for j in 1:r
                        avl[j] += curr[i, j]
                    end
                    break
                end
            end
        end

        if !safe
            println("The processes are in an unsafe state.")
            break
        end

        println("\nThe process is in a safe state.")
        println("\nAvailable Vector: $avl")
    end
end

testbankers()
