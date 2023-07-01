-- get smallest number <= sqrt(269696)
k = math.floor(math.sqrt(269696))

-- if root is odd -> make it even
if k % 2 == 1 then
    k = k - 1
end

-- cycle through numbers
while not ((k * k) % 1000000 == 269696) do
    k = k + 2
end

io.write(string.format("%d * %d = %d\n", k, k, k * k))
