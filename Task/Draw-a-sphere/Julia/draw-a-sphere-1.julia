function draw_sphere(r, k, ambient, light)
    shades = ('.', ':', '!', '*', 'o', 'e', '&', '#', '%', '@')
    for i in floor(Int, -r):ceil(Int, r)
        x = i + 0.5
        line = IOBuffer()
        for j in floor(Int, -2r):ceil(2r)
            y = j / 2 + 0.5
            if x ^ 2 + y ^ 2 ≤ r ^ 2
                v = normalize([x, y, sqrt(r ^ 2 - x ^ 2 - y ^ 2)])
                b = dot(light, v) ^ k + ambient
                intensity = ceil(Int, (1 - b) * (length(shades) - 1))
                if intensity < 1
                    intensity = 1 end
                if intensity > length(shades)
                    intensity = length(shades) end
                print(shades[intensity])
            else
                print(' ')
            end
        end
        println()
    end
end

light = normalize([30, 30, -50])
draw_sphere(20, 4, 0.1, light)
draw_sphere(10, 2, 0.4, light)
