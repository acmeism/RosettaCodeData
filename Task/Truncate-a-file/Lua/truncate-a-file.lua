function truncate (filename, length)
    local inFile = io.open(filename, 'r')
    if not inFile then
        error("Specified filename does not exist")
    end
    local wholeFile = inFile:read("*all")
    inFile:close()
    if length >= wholeFile:len() then
        error("Provided length is not less than current file length")
    end
    local outFile = io.open(filename, 'w')
    outFile:write(wholeFile:sub(1, length))
    outFile:close()
end
