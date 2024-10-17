const nrequests = [0]
const ordering = Dict("violet" => 7, "red" => 1, "green" => 4, "indigo" => 6, "blue" => 5,
                      "yellow" => 3, "orange" => 2)

function tellmeifgt(x, y)
    nrequests[1] += 1
    while true
        print("Is $x greater than $y?  (Y/N) =>  ")
        s = strip(readline())
        if length(s) > 0
            (s[1] == 'Y' || s[1] == 'y') && return true
            (s[1] == 'N' || s[1] == 'n') && return false
        end
    end
end

function orderbypair!(a::Vector)
    incr = div(length(a), 2)
    while incr > 0
        for i in incr+1:length(a)
            j = i
            tmp = a[i]
            while j > incr && tellmeifgt(a[j - incr], tmp)
                a[j] = a[j-incr]
                j -= incr
            end
            a[j] = tmp
        end
        if incr == 2
            incr = 1
        else
            incr = floor(Int, incr * 5.0 / 11)
        end
    end
    return a
end

const words = String.(split("violet red green indigo blue yellow orange", r"\s+"))
println("Unsorted: $words")
println("Sorted: $(orderbypair!(words)). Total requests: $(nrequests[1]).")
