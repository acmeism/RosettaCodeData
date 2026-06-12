function writeValue(v)
    local t = type(v)
    if t == "number" then
        io.write(v)
    elseif t == "string" then
        io.write("`" .. v .. "`")
    elseif t == "table" then
        local c = 0
        io.write("{")
        for k,v in pairs(v) do
            if c > 0 then
                io.write(", ")
            end
            writeValue(k)
            io.write(" => ")
            writeValue(v)
            c = c + 1
        end
        io.write("}")
    elseif t == "function" then
        io.write("`" .. tostring(v) .. "`")
    else
        io.write("Unhandled type: " .. t)
    end
end

function printType(v)
    io.write("The value ")
    writeValue(v)
    print(" is of type " .. type(v))
end

function main()
    printType(42)
    printType(3.14)
    printType("hello world")
    printType({1, 2, 3, 4, 5})
    printType(main)
end

main()
