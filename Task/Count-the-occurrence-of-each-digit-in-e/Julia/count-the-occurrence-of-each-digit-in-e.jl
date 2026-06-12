const MaxIDx = 2000
v = ones(Int, MaxIDx)  # Initialize array v with all 1s

dcount = [0, 0, 1, 0, 0, 0, 0, 0, 0, 0]

# Main calculation
for col = 0:(2 * MaxIDx)
    a = MaxIDx + 1
    c = 0

    for i = 1:MaxIDx
        c += v[i] * 10
        v[i] = c % a  # Modulo operation
        c = div(c, a) # Integer division
        a -= 1
    end

    dcount[c + 1] += 1  # Julia arrays are 1-indexed
end

println(join(dcount, " "))
