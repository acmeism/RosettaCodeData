# v0.6

function shellsort!(a::Array{Int})::Array{Int}
    incr = div(length(a), 2)
    while incr > 0
        for i in incr+1:length(a)
            j = i
            tmp = a[i]
            while j > incr && a[j - incr] > tmp
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

x = rand(1:10, 10)
@show x shellsort!(x)
@assert issorted(x)
