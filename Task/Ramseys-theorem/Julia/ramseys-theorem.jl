const a, idx = zeros(Int, 17, 17), zeros(Int, 4)

function findgroup(typ, nmin, nmax, depth)
    if depth == 4
        print("Totally ", typ > 0 ? "" : "un", "connected group:")
        for i in 1:4
            print(" ", idx[i], i == 4 ? "\n" : "")
        end
        return true
    end
    for i in nmin:nmax-1
        for i in nmin:nmax-1
            m = 0
            for n in 0:depth-1
                if a[idx[n + 1] + 1, i + 1] != typ
                    break
                end
                m = n +1
            end
            if m == depth
                idx[m + 1] = i
                if findgroup(typ, 1, nmax, depth + 1)
                    return true
                end
            end
        end
    end
    return false
end

function testnodes()
    mark = "01-"
    for i in 1:17
        a[i, i] = 2
    end
    for k in [1, 2, 4, 8], i in 0:16
        j = (i + k) % 17
        a[i + 1, j + 1] = a[j + 1, i + 1] = 1
    end
    for i in 1:17, j in 1:17
        print(mark[a[i, j] + 1], j == 17 ? "\n" : " ")
    end

    # testcase breakage
    # a[2][1] = a[1][2] = 0
    # it's symmetric, so only need to test groups containing node 0
    for i in 1:17
        idx[1] = i
        if findgroup(1, i + 1, 17, 1) || findgroup(0, i + 1, 17, 1)
            println("Test with $i is no good.")
            return
        end
    end
    println("All tests are OK.")
end

testnodes()
