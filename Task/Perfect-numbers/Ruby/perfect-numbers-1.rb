def perf(n)
    sum = 0
    for i in 1...n
        if n % i == 0
            sum += i
        end
    end
    return sum == n
end
