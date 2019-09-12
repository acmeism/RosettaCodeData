swapa(a, i, j) = begin a[i], a[j] = a[j], a[i] end

function pd!(a, first, last)
    while (c = 2 * first - 1) < last
        if c < last && a[c] < a[c + 1]
            c += 1
        end
        if a[first] < a[c]
            swapa(a, c, first)
            first = c
        else
            break
        end
    end
end

hfy!(a, n) = (f = div(n, 2); while f >= 1 pd!(a, f, n); f -= 1 end)

heapsort!(a) = (n = length(a); hfy!(a, n); l = n; while l > 1 swapa(a, 1, l); l -= 1; pd!(a, 1, l) end; a)

a = shuffle(collect(1:12))
println("Unsorted: $a")
println("Heap sorted: ", heapsort!(a))
