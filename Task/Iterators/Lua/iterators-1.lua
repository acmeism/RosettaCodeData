for i, v in ipairs({ "a", "b", "c" }) do
    print(i, v)  -- prints 1 a 2 b 3 c
end
for k, v in pairs({ key = "value" }) do
    print(k, v)  -- prints key value
end
