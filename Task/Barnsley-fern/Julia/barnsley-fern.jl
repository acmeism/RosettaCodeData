using Images

mutable struct BarnsleyFern
    width::Int
    height::Int
    color::RGB
    x::Float64
    y::Float64
    fern::Matrix{RGB}
    function BarnsleyFern(width, height, color = RGB(0.0, 1.0, 0.0), bgcolor = RGB(0.0, 0.0, 0.0))
        img = [bgcolor for x in 1:width, y in 1:height]
        cx = Int(floor(2.182 * (width - 1) / 4.8378) + 1)
        cy = Int(floor(9.9983 * (height - 1) / 9.9983) + 1)
        img[cx, cy] = color
        return new(width, height, color, 0.0, 0.0, img)
    end
end

function transform(f::BarnsleyFern)
    r = rand(0:99)
    f.x, f.y = r < 1 ? (0.0, 0.16 * f.y) :
        1 <= r < 86 ?  (0.85 * f.x + 0.04 * f.y, -0.04 * f.x + 0.85 * f.y + 1.6) :
        86 <= r < 93 ? (0.2 * f.x - 0.26 * f.y, 0.23 * f.x + 0.22 * f.y + 1.6) :
        (-0.15 * f.x + 0.28 * f.y, 0.26 * f.x + 0.24 * f.y + 0.44)
    cx = Int(floor((f.x + 2.182) * (f.width - 1) / 4.8378) + 1)
    cy = Int(floor((9.9983 - f.y) * (f.height - 1) / 9.9983) + 1)
    f.fern[cx, cy] = f.color
end

const fern = BarnsleyFern(500, 500)
for _ in 1:1000000
    transform(fern)
end
fern.fern'
