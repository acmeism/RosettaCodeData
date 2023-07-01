function swap(a, i, j)
    a[i], a[j] = a[j], a[i]
end

function pd!(a, first, last)
    while (c = 2 * first - 1) < last
        if c < last && a[c] < a[c + 1]
            c += 1
        end
        if a[first] < a[c]
            swap(a, c, first)
            first = c
        else
            break
        end
    end
end

function heapify!(a, n)
    f = div(n, 2)
    while f >= 1
        pd!(a, f, n)
        f -= 1
    end
end

function heapsort!(a)
    n = length(a)
    heapify!(a, n)
    l = n
    while l > 1
        swap(a, 1, l)
        l -= 1
        pd!(a, 1, l)
    end
    return a
end

using Random: shuffle
a = shuffle(collect(1:12))
println("Unsorted: $a")
println("Heap sorted: ", heapsort!(a))
