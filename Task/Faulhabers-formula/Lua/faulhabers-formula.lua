function binomial(n,k)
    if n<0 or k<0 or n<k then return -1 end
    if n==0 or k==0 then return 1 end

    local num = 1
    for i=k+1,n do
        num = num * i
    end

    local denom = 1
    for i=2,n-k do
        denom = denom * i
    end

    return num / denom
end

function gcd(a,b)
    while b ~= 0 do
        local temp = a % b
        a = b
        b = temp
    end
    return a
end

function makeFrac(n,d)
    local result = {}

    if d==0 then
        result.num = 0
        result.denom = 0
        return result
    end

    if n==0 then
        d = 1
    elseif d < 0 then
        n = -n
        d = -d
    end

    local g = math.abs(gcd(n, d))
    if g>1 then
        n = n / g
        d = d / g
    end

    result.num = n
    result.denom = d
    return result
end

function negateFrac(f)
    return makeFrac(-f.num, f.denom)
end

function subFrac(lhs, rhs)
    return makeFrac(lhs.num * rhs.denom - lhs.denom * rhs.num, rhs.denom * lhs.denom)
end

function multFrac(lhs, rhs)
    return makeFrac(lhs.num * rhs.num, lhs.denom * rhs.denom)
end

function equalFrac(lhs, rhs)
    return (lhs.num == rhs.num) and (lhs.denom == rhs.denom)
end

function lessFrac(lhs, rhs)
    return (lhs.num * rhs.denom) < (rhs.num * lhs.denom)
end

function printFrac(f)
    io.write(f.num)
    if f.denom ~= 1 then
        io.write("/"..f.denom)
    end
    return nil
end

function bernoulli(n)
    if n<0 then
        return {num=0, denom=0}
    end

    local a = {}
    for m=0,n do
        a[m] = makeFrac(1, m+1)
        for j=m,1,-1 do
            a[j-1] = multFrac(subFrac(a[j-1], a[j]), makeFrac(j, 1))
        end
    end

    if n~=1 then
        return a[0]
    end
    return negateFrac(a[0])
end

function faulhaber(p)
    io.write(p.." : ")
    local q = makeFrac(1, p+1)
    local sign = -1
    for j=0,p do
        sign = -1 * sign
        local coeff = multFrac(multFrac(multFrac(q, makeFrac(sign, 1)), makeFrac(binomial(p + 1, j), 1)), bernoulli(j))
        if not equalFrac(coeff, makeFrac(0, 1)) then
            if j==0 then
                if not equalFrac(coeff, makeFrac(1, 1)) then
                    if equalFrac(coeff, makeFrac(-1, 1)) then
                        io.write("-")
                    else
                        printFrac(coeff)
                    end
                end
            else
                if equalFrac(coeff, makeFrac(1, 1)) then
                    io.write(" + ")
                elseif equalFrac(coeff, makeFrac(-1, 1)) then
                    io.write(" - ")
                elseif lessFrac(makeFrac(0, 1), coeff) then
                    io.write(" + ")
                    printFrac(coeff)
                else
                    io.write(" - ")
                    printFrac(negateFrac(coeff))
                end
            end

            local pwr = p + 1 - j
            if pwr>1 then
                io.write("n^"..pwr)
            else
                io.write("n")
            end
        end
    end
    print()
    return nil
end

-- main
for i=0,9 do
    faulhaber(i)
end
