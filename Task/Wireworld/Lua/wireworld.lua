local map = {{'t', 'H', '.', '.', '.', '.', '.', '.', '.', '.', '.'},
             {'.', ' ', ' ', ' ', '.'},
             {' ', ' ', ' ', '.', '.', '.'},
             {'.', ' ', ' ', ' ', '.'},
             {'H', 't', '.', '.', ' ', '.', '.', '.', '.', '.', '.'}}

function step(map)
    local next = {}
    for i = 1, #map do
        next[i] = {}
        for j = 1, #map[i] do
            next[i][j] = map[i][j]
            if map[i][j] == "H" then
                next[i][j] = "t"
            elseif map[i][j] == "t" then
                next[i][j] = "."
            elseif map[i][j] == "." then
                local count = 	((map[i-1] or {})[j-1] == "H" and 1 or 0) +
                                ((map[i-1] or {})[j] == "H" and 1 or 0) +
                                ((map[i-1] or {})[j+1] == "H" and 1 or 0) +
                                ((map[i] or {})[j-1] == "H" and 1 or 0) +
                                ((map[i] or {})[j+1] == "H" and 1 or 0) +
                                ((map[i+1] or {})[j-1] == "H" and 1 or 0) +
                                ((map[i+1] or {})[j] == "H" and 1 or 0) +
                                ((map[i+1] or {})[j+1] == "H" and 1 or 0)
                if count == 1 or count == 2 then
                    next[i][j] = "H"
                else
                    next[i][j] = "."
                end
            end
        end
    end
    return next
end

if not not love then
    local time, frameTime, size = 0, 0.25, 20
    local colors = {["."] = {255, 200, 0},
                    ["t"] = {255, 0, 0},
                    ["H"] = {0, 0, 255}}
    function love.update(dt)
        time = time + dt
        if time > frameTime then
            time = time - frameTime
            map = step(map)
        end
    end

    function love.draw()
        for i = 1, #map do
            for j = 1, #map[i] do
                love.graphics.setColor(colors[map[i][j]] or {0, 0, 0})
                love.graphics.rectangle("fill", j*size, i*size, size, size)
            end
        end
    end
else
    for iter = 1, 10 do
        print("\nstep "..iter.."\n")
        for i = 1, #map do
            for j = 1, #map[i] do
                io.write(map[i][j])
            end
            io.write("\n")
        end
        map = step(map)
    end
end
