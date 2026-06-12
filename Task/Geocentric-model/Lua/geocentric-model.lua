function love.load()
    love.window.setTitle("Geocentric model - Lua + LÖVE2D")
    width, height = 800, 800
    cx, cy = width/2, height/2

    planets = {
        {"Moon",     70,  0.01,  6, 0, {200,200,200}},
        {"Mercury", 120,  0.008, 5, 0, {150,150,150}},
        {"Venus",   170,  0.006, 9, 0, {255,200,0}},
        {"Sun",     230,  0.004,18, 0, {255,150,0}},
        {"Mars",    300,  0.003, 7, 0, {255,50,0}},
        {"Jupiter", 360,  0.002,15, 0, {200,150,100}}
    }
	
	print("--- Planet Colors ---")
	for _,p in ipairs(planets) do
		print(string.format("%-10s %-10s", p[1], p[7]))
	end
	print("---------------------")
end

function love.update(dt)
    for i,p in ipairs(planets) do
        p[5] = p[5] + p[3]   -- angle += speed
    end
end

function love.draw()
    love.graphics.setBackgroundColor(5/255, 5/255, 20/255)

    for i,p in ipairs(planets) do
        local name, dist, speed, size, angle, color =
              p[1], p[2], p[3], p[4], p[5], p[6]

        -- orbit
        love.graphics.setColor(60/255, 60/255, 60/255)
        love.graphics.circle("line", cx, cy, dist)

        -- planet position
        local px = cx + math.cos(angle) * dist
        local py = cy + math.sin(angle) * dist

        -- planet
        love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255)
        love.graphics.circle("fill", px, py, size)

        -- label
        love.graphics.setColor(1,1,1)
        love.graphics.print(name, px + size + 8, py - 6)
    end
end
