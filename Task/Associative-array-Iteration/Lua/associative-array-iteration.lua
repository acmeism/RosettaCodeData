local t = {
    ["foo"] = "bar",
    ["baz"] = 6,
    fortytwo = 7
}

for key,val in pairs(t) do
    print(string.format("%s: %s", key, val))
end
