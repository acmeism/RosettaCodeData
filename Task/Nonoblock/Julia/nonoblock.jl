minsized(arr) = join(map(x->"#"^x, arr), ".")
minlen(arr) = sum(arr) + length(arr) - 1

function sequences(blockseq, numblanks)
    if isempty(blockseq)
        return ["." ^ numblanks]
    elseif minlen(blockseq) == numblanks
        return minsized(blockseq)
    else
        result = Vector{String}()
        allbuthead = blockseq[2:end]
        for leftspace in 0:(numblanks - minlen(blockseq))
            header = "." ^ leftspace * "#" ^ blockseq[1] * "."
            rightspace = numblanks - length(header)
            if isempty(allbuthead)
                push!(result, rightspace <= 0 ? header[1:numblanks] : header * "." ^ rightspace)
            elseif minlen(allbuthead) == rightspace
                push!(result, header * minsized(allbuthead))
            else
                map(x -> push!(result, header * x), sequences(allbuthead, rightspace))
            end
        end
    end
    result
end

function nonoblocks(bvec, len)
    println("With blocks $bvec and $len cells:")
    len < minlen(bvec) ? println("No solution") : for seq in sequences(bvec, len) println(seq) end
end

nonoblocks([2, 1], 5)
nonoblocks(Vector{Int}([]), 5)
nonoblocks([8], 10)
nonoblocks([2, 3, 2, 3], 15)
nonoblocks([2, 3], 5)
