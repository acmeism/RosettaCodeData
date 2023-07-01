actual = {}
expected = {}
for i = 1, 9 do
    actual[i] = 0
    expected[i] = math.log10(1 + 1 / i)
end

n = 0
file = io.open("fibs1000.txt", "r")
for line in file:lines() do
    digit = string.byte(line, 1) - 48
    actual[digit] = actual[digit] + 1
    n = n + 1
end
file:close()

print("digit   actual  expected")
for i = 1, 9 do
    print(i, actual[i] / n, expected[i])
end
