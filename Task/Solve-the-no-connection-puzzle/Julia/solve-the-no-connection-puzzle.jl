using Combinatorics

const HOLES = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
const PEGS = [1, 2, 3, 4, 5, 6, 7, 8]
const EDGES = [('A', 'C'), ('A', 'D'), ('A', 'E'),
               ('B', 'D'), ('B', 'E'), ('B', 'F'),
               ('C', 'G'), ('C', 'D'), ('D', 'G'),
               ('D', 'E'), ('D', 'H'), ('E', 'F'),
               ('E', 'G'), ('E', 'H'), ('F', 'H')]

goodperm(p) = all(e->abs(p[e[1]-'A'+1] - p[e[2]-'A'+1]) > 1, EDGES)

goodplacements() = [p for p in permutations(PEGS) if goodperm(p)]

const BOARD = raw"""
        A   B
       /|\ /|\
      / | X | \
     /  |/ \|  \
    C - D - E - F
     \  |\ /|  /
      \ | X | /
       \|/ \|/
        G   H
"""

function printsolutions()
    solutions = goodplacements()
    println("Found $(length(solutions)) solutions.")
    for soln in solutions
        board = BOARD
        for (i, n) in enumerate(soln)
            board = replace(board, string('A' + i - 1) => string(n))
        end
        println(board); exit(1) # remove this exit for all solutions
    end
end

printsolutions()
