words = ["a", "bc", "abc", "cd", "b"]
strings = ["abcd", "abbc", "abcbcd", "acdbc", "abcdd"]

subregex = join(words, ")|(")
regexes = ["\^\(\($subregex\)\)\{$i}\$" for i in 6:-1:1]

function wordbreak()
    for s in strings
        solutions = []
        for regex in regexes
            rmat = match(Regex(regex), s)
            if rmat != nothing
                push!(solutions, ["$w" for w in Set(rmat.captures) if w != nothing])
            end
        end
        if length(solutions) > 0
            println("$(length(solutions)) Solution(s) for $s:")
            for sol in solutions
                println("   Solution: $(sol)")
            end
        else
            println("No solutions for $s : No fitting matches found.")
        end
    end
end

wordbreak()
