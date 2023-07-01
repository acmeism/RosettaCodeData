const branches = 4
const nmax = 500

const rooted = zeros(BigInt, nmax + 1)
const unrooted = zeros(BigInt, nmax + 1)
rooted[1] = rooted[2] = unrooted[1] = unrooted[2] = 1
const c = zeros(BigInt, branches)

function tree(br, n, l, sum, cnt)
    for b in br+1:branches
        sum += n
        if (sum > nmax) || (l * 2 >= sum && b >= branches)
            return
        elseif b == br + 1
            c[br + 1] = rooted[n + 1] * cnt
        else
            c[br + 1] *= rooted[n + 1] + b - br - 1
            c[br + 1] = div(c[br + 1], b - br)
        end
        if l*2 < sum
            unrooted[sum + 1] += c[br + 1]
        end
        if b < branches
            rooted[sum + 1] += c[br + 1]
        end
        for m in n-1:-1:1
            tree(b, m, l, sum, c[br + 1])
        end
    end
end

bicenter(n) = if iseven(n) unrooted[n + 1] += div(rooted[div(n, 2) + 1] * (rooted[div(n, 2) + 1] + 1), 2) end

function paraffins()
    for n in 1:nmax
        tree(0, n, n, 1, one(BigInt))
        bicenter(n)
        println("$n: $(unrooted[n + 1])")
    end
end

paraffins()
