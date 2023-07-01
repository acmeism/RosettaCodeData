using Images, FileIO

function main(h::Integer, w::Integer, side::Bool=false)
    W0 = w >> 1
    H0 = h >> 1
    @inline function motecolor(x::Integer, y::Integer)
        h = clamp(180 * (atan2(y - H0, x - W0) / π + 1.0), 0.0, 360.0)
        return HSV(h, 0.5, 0.5)
    end

    img = zeros(RGB{N0f8}, h, w)
    img[H0, W0] = RGB(1, 1, 1)
    free = trues(h, w)
    free[H0, W0] = false
    for i in eachindex(img)
        x = rand(1:h)
        y = rand(1:w)
        free[x, y] || continue
        mc = motecolor(x, y)
        for j in 1:1000
            xp = x + rand(-1:1)
            yp = y + rand(-1:1)
            contained = checkbounds(Bool, img, xp, yp)
            if contained && free[xp, yp]
                x, y = xp, yp
                continue
            else
                if side || (contained && !free[xp, yp])
                    free[x, y] = false
                    img[x, y] = mc
                end
                break
            end
        end
    end
    return img
end

imgnoside = main(256, 256)
imgwtside = main(256, 256, true)
save("data/browniantree_noside.jpg", imgnoside)
save("data/browniantree_wtside.jpg", imgwtside)
