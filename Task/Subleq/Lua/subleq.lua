function subleq (prog)
    local mem, p, A, B, C = {}, 0
    for word in prog:gmatch("%S+") do
        mem[p] = tonumber(word)
        p = p + 1
    end
    p = 0
    repeat
        A, B, C = mem[p], mem[p + 1], mem[p + 2]
        if A == -1 then
            mem[B] = io.read()
        elseif B == -1 then
            io.write(string.char(mem[A]))
        else
            mem[B] = mem[B] - mem[A]
            if mem[B] <= 0 then p = C end
        end
        p = p + 3
    until not mem[mem[p]]
end

subleq("15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1 72 101 108 108 111 44 32 119 111 114 108 100 33 10 0")
