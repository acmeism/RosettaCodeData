def mod(x, y)
    m = x % y
    if m < 0 then
        if y < 0 then
            return m - y
        else
            return m + y
        end
    end
    return m
end

# Constants
# First generator
A1 = [0, 1403580, -810728]
A1.freeze
M1 = (1 << 32) - 209
# Second generator
A2 = [527612, 0, -1370589]
A2.freeze
M2 = (1 << 32) - 22853

D = M1 + 1

# the last three values of the first generator
$x1 = [0, 0, 0]
# the last three values of the second generator
$x2 = [0, 0, 0]

def seed(seed_state)
    $x1 = [seed_state, 0, 0]
    $x2 = [seed_state, 0, 0]
end

def next_int()
    x1i = mod((A1[0] * $x1[0] + A1[1] * $x1[1] + A1[2] * $x1[2]), M1)
    x2i = mod((A2[0] * $x2[0] + A2[1] * $x2[1] + A2[2] * $x2[2]), M2)
    z = mod(x1i - x2i, M1)

    $x1 = [x1i, $x1[0], $x1[1]]
    $x2 = [x2i, $x2[0], $x2[1]]

    return z + 1
end

def next_float()
    return 1.0 * next_int() / D
end

########################################

seed(1234567)
print next_int(), "\n"
print next_int(), "\n"
print next_int(), "\n"
print next_int(), "\n"
print next_int(), "\n"
print "\n"

counts = [0, 0, 0, 0, 0]
seed(987654321)
for i in 1 .. 100000
    value = (next_float() * 5.0).floor
    counts[value] = counts[value] + 1
end
counts.each_with_index { |v,i|
    print i, ": ", v, "\n"
}
