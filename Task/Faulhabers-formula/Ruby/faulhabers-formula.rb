def binomial(n,k)
    if n < 0 or k < 0 or n < k then
        return -1
    end
    if n == 0 or k == 0 then
        return 1
    end

    num = 1
    for i in k+1 .. n do
        num = num * i
    end

    denom = 1
    for i in 2 .. n-k do
        denom = denom * i
    end

    return num / denom
end

def bernoulli(n)
    if n < 0 then
        raise "n cannot be less than zero"
    end

    a = Array.new(16)
    for m in 0 .. n do
        a[m] = Rational(1, m + 1)
        for j in m.downto(1) do
            a[j-1] = (a[j-1] - a[j]) * Rational(j)
        end
    end

    if n != 1 then
        return a[0]
    end
    return -a[0]
end

def faulhaber(p)
    print("%d : " % [p])
    q = Rational(1, p + 1)
    sign = -1
    for j in 0 .. p do
        sign = -1 * sign
        coeff = q * Rational(sign) * Rational(binomial(p+1, j)) * bernoulli(j)
        if coeff == 0 then
            next
        end
        if j == 0 then
            if coeff != 1 then
                if coeff == -1 then
                    print "-"
                else
                    print coeff
                end
            end
        else
            if coeff == 1 then
                print " + "
            elsif coeff == -1 then
                print " - "
            elsif 0 < coeff then
                print " + "
                print coeff
            else
                print " - "
                print -coeff
            end
        end
        pwr = p + 1 - j
        if pwr > 1 then
            print "n^%d" % [pwr]
        else
            print "n"
        end
    end
    print "\n"
end

def main
    for i in 0 .. 9 do
        faulhaber(i)
    end
end

main()
