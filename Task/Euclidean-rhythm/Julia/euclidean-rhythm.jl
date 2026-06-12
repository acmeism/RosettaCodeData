function E(k, n)
    s = [[i <= k ? 1 : 0] for i in 1:n]

    d = n - k
    n, k = max(k, d), min(k, d)
    z = d

    while z > 0 || k > 1
        for i in 1:k
            append!(s[i], s[end - i + 1])
        end
        s = s[1:end-k]
        z -= k
        d = n - k
        n, k = max(k, d), min(k, d)
    end

    return vcat(s...)
end

# Test the function
print(join(E(5, 13), ""))
# Output should be 1001010010100
