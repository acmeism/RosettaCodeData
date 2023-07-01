on josephus(n, k)
    set m to 0
    repeat with i from 2 to n
        set m to (m + k) mod i
    end repeat

    return m + 1
end josephus

josephus(41, 3) --> 31
