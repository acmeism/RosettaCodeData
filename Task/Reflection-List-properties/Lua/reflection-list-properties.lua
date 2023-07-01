a = 1
b = 2.0
c = "hello world"

function listProperties(t)
    if type(t) == "table" then
        for k,v in pairs(t) do
            if type(v) ~= "function" then
                print(string.format("%7s: %s", type(v), k))
            end
        end
    end
end

print("Global properties")
listProperties(_G)
print("Package properties")
listProperties(package)
