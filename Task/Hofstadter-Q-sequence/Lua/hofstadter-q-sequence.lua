function hofstadter (limit)
    local Q = {1, 1}
    for n = 3, limit do
        Q[n] = Q[n - Q[n - 1]] + Q[n - Q[n - 2]]
    end
    return Q
end

function countDescents (t)
    local count = 0
    for i = 2, #t do
        if t[i] < t[i - 1] then
            count = count + 1
        end
    end
    return count
end

local noError, hofSeq = pcall(hofstadter, 1e5)
if noError == false then
    print("The sequence could not be calculated up to the specified limit.")
    os.exit()
end
for i = 1, 10 do
    io.write(hofSeq[i] .. " ")
end
print("\n" .. hofSeq[1000])
print(countDescents(hofSeq))
