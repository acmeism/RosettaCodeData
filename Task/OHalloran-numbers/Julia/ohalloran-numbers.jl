""" Rosetta code task: rosettacode.org/wiki/O%27Halloran_numbers """

const max_area, half_max = 1000, 500
const areas = trues(max_area)

areas[1:2:max_area] .= false

for i in 1:max_area
    for j in 1:half_max
        i * j > half_max && break
        for k in 1:half_max
            area = 2 * (i * j + i * k + j * k)
            area > max_area && break
            areas[area] = false
        end
    end
end

println("Even surface areas < $max_area NOT achievable by any regular integer-valued cuboid:\n",
    [n for n in eachindex(areas) if areas[n]])
