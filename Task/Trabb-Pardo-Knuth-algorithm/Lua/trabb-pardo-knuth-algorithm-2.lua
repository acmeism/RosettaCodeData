local a, y = {}
function f (t)
    return math.sqrt(math.abs(t)) + 5*t^3
end
for i = 0, 10 do a[i] = io.read() end
for i = 10, 0, -1 do
    y = f(a[i])
    if y > 400 then print(i, "TOO LARGE")
               else print(i, y) end
end
