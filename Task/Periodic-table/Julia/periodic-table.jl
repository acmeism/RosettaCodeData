const limits = [3:10, 11:18, 19:36, 37:54, 55:86, 87:118]

function periodic_table(n)
    (n < 1 || n > 118) && error("Atomic number is out of range.")
    n == 1 && return [1, 1]
    n == 2 && return [1, 18]
    57 <= n <= 71 && return [8, n - 53]
    89 <= n <= 103 && return [9, n - 85]
    row, limitstart, limitstop = 0, 0, 0
    for i in eachindex(limits)
        if limits[i].start <= n <= limits[i].stop
            row, limitstart, limitstop = i + 1, limits[i].start, limits[i].stop
            break
        end
    end
    return (n < limitstart + 2 || row == 4 || row == 5) ?
        [row, n - limitstart + 1] : [row, n - limitstop + 18]
end

for n in [1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113]
    rc = periodic_table(n)
    println("Atomic number ", lpad(n, 3), " -> ($(rc[1]), $(rc[2]))")
end
