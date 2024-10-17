using Primes

function ulamspiral(ord::Int)
    # Possible directions
    dirs = [[0, 1], [-1, 0], [0, -1], [1, 0]]
    # fdir = ["→", "↑", "←", "↓"] # for debug pourpose
    cur = maxsteps = 1  # starting direction & starting max steps
    steps = n = 0       # starting steps     & starting number in cell
    pos = [ord ÷ 2 + 1, isodd(ord) ? ord ÷ 2 + 1 : ord ÷ 2] # starting position
    M = Matrix{Bool}(ord, ord) # result matrix
    while n < ord ^ 2  # main loop (stop when the matrix is filled)
        n += 1
        M[pos[1], pos[2]] = isprime(n)
        steps += 1
        # Debug print
        # @printf("M[%i, %i] = %5s (%2i), step %i/%i, nxt %s\n", pos[1], pos[2], isprime(n), n, steps, maxsteps, fdir[cur])
        pos  .+= dirs[cur] # increment position
        if steps == maxsteps # if reached max number of steps in that direction...
            steps = 0        # ...reset steps
            if iseven(cur) maxsteps += 1 end # if the current direction is even increase the number of steps
            cur  += 1        # change direction
            if cur > 4 cur -= 4 end # correct overflow
        end
    end
    return M
end

mprint(m::Matrix) = for i in 1:size(m, 1) println(join(el ? " ∙ " : "   " for el in m[i, :]), '\n') end

M = ulamspiral(9)
mprint(M)
