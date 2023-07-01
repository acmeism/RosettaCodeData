using Gadfly
using DataFrames

const xarray = zeros(Float64, 80000)
const yarray = zeros(Float64, 80000)
const arraypos = ones(Int32,1)
const maxdepth = zeros(Int32, 1)


function addpoints(x1, y1, x2, y2)
    xarray[arraypos[1]] = x1
    xarray[arraypos[1]+1] = x2
    yarray[arraypos[1]] = y1
    yarray[arraypos[1]+1] = y2
    arraypos[1] += 2
end


function pythtree(ax, ay, bx, by, depth)
    if(depth > maxdepth[1])
        return
    end
    dx=bx-ax; dy=ay-by;
    x3=bx-dy; y3=by-dx;
    x4=ax-dy; y4=ay-dx;
    x5=x4+(dx-dy)/2; y5=y4-(dx+dy)/2;
    addpoints(ax, ay, bx, by)
    addpoints(bx, by, x3, y3)
    addpoints(x3, y3, x4, y4)
    addpoints(x4, y4, ax, ay)
    pythtree(x4, y4, x5, y5, depth + 1)
    pythtree(x5, y5, x3, y3, depth + 1)
end


function pythagorastree(x1, y1, x2, y2, size, maxdep)
    maxdepth[1] = maxdep
    println("Pythagoras Tree, depth $(maxdepth[1]), size $size, starts at ($x1, $y1, $x2, $y2)");
    pythtree(x1, y1, x2, y2, 0);
    df = DataFrame(x=xarray[1:arraypos[1]-1], y=-yarray[1:arraypos[1]-1])
    plot(df, x=:x, y=:y, Geom.path(), Theme(default_color="green", point_size=0.4mm))
end

pythagorastree(275.,500.,375.,500.,640., 9)
