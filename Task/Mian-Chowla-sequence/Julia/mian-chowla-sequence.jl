function mianchowla(n)
    seq = ones(Int, n)
    sums = Dict{Int,Int}()
    tempsums = Dict{Int,Int}()
    for i in 2:n
        seq[i] = seq[i - 1] + 1
        incrementing = true
        while incrementing
            for j in 1:i
                tsum = seq[j] + seq[i]
                if haskey(sums, tsum)
                    seq[i] += 1
                    empty!(tempsums)
                    break
                else
                    tempsums[tsum] = 0
                    if j == i
                        merge!(sums, tempsums)
                        empty!(tempsums)
                        incrementing = false
                    end
                end
            end
        end
    end
    seq
end

function testmianchowla()
    println("The first 30 terms of the Mian-Chowla sequence are $(mianchowla(30)).")
    println("The 91st through 100th terms of the Mian-Chowla sequence are $(mianchowla(100)[91:100]).")
end

testmianchowla()
@time testmianchowla()
