function helloWorld()
    print "Hello World"
end

-- Will list all functions in the given table, but does not recurse into nexted tables
function printFunctions(t)
    local s={}
    local n=0
    for k in pairs(t) do
        n=n+1 s[n]=k
    end
    table.sort(s)
    for k,v in ipairs(s) do
        f = t[v]
        if type(f) == "function" then
            print(v)
        end
    end
end

printFunctions(_G)
