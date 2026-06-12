""" Modified from MATLAB example code at en.wikipedia.org/wiki/CORDIC """

using Printf

"""
    Compute v = [cos(alpha), sin(alpha)] (alpha in radians).
    Increasing the iteration value will increase the precision.
"""
function cordic(alpha, iteration = 24)
    # Fix for the Wikipedia's MATLAB code bug in sin (sometimes flips sign) when |θ| > 2π
    newsgn = isodd(Int(floor(alpha / 2π))) ? 1 : -1
    alpha < -π/2 && return newsgn * cordic(alpha + π, iteration)
    alpha > π/2 && return newsgn * cordic(alpha - π, iteration)

    # Initialization of tables of constants used by CORDIC
    # need a table of arctangents of negative powers of two, in radians:
    # angles = atan(2.^-(0:27));
    angles =  [
        0.78539816339745,   0.46364760900081,   0.24497866312686,   0.12435499454676,
        0.06241880999596,   0.03123983343027,   0.01562372862048,   0.00781234106010,
        0.00390623013197,   0.00195312251648,   0.00097656218956,   0.00048828121119,
        0.00024414062015,   0.00012207031189,   0.00006103515617,   0.00003051757812,
        0.00001525878906,   0.00000762939453,   0.00000381469727,   0.00000190734863,
        0.00000095367432,   0.00000047683716,   0.00000023841858,   0.00000011920929,
        0.00000005960464,   0.00000002980232,   0.00000001490116,   0.00000000745058, ]
    # and a table of products of reciprocal lengths of vectors [1, 2^-2j]:
    # Kvalues = cumprod(1./sqrt(1 + 1j*2.^(-(0:23))))
    Kvalues = [
        0.70710678118655,   0.63245553203368,   0.61357199107790,   0.60883391251775,
        0.60764825625617,   0.60735177014130,   0.60727764409353,   0.60725911229889,
        0.60725447933256,   0.60725332108988,   0.60725303152913,   0.60725295913894,
        0.60725294104140,   0.60725293651701,   0.60725293538591,   0.60725293510314,
        0.60725293503245,   0.60725293501477,   0.60725293501035,   0.60725293500925,
        0.60725293500897,   0.60725293500890,   0.60725293500889,   0.60725293500888, ]

    Kn = Kvalues[min(iteration, length(Kvalues))]
    # Initialize loop variables:
    v = [1, 0] # start with 2-vector cosine and sine of zero
    poweroftwo = 1
    angle = angles[1]

    # Iterations
    for j = 0:iteration-1
        if alpha < 0
            sigma = -1
        else
            sigma = 1
        end
        factor = sigma * poweroftwo
        # Note the matrix multiplication can be done using scaling by powers of two and addition subtraction
        R = [1 -factor
             factor  1]
        v = R * v # 2-by-2 matrix multiply
        alpha -= sigma * angle # update the remaining angle
        poweroftwo /= 2
        # update the angle from table, or eventually by just dividing by two
        if j + 2 > length(angles)
            angle /= 2
        else
            angle = angles[j + 2]
        end
    end

    # Adjust length of output vector to be [cos(alpha), sin(alpha)]:
    v .*= Kn
    return v
end

function test_cordic()
    println("  x       sin(x)     diff. sine     cos(x)    diff. cosine ")
    for θ in -90:15:90
        cosθ, sinθ = cordic(deg2rad(θ))
        @printf("%+05.1f°  %+.8f (%+.8f) %+.8f (%+.8f)\n",
           θ, sinθ, sinθ - sind(θ), cosθ, cosθ - cosd(θ))
    end
    println("\nx(radians)  sin(x)     diff. sine     cos(x)    diff. cosine ")
    for θr in [-9, 0, 1.5, 6]
        cosθ, sinθ = cordic(θr)
        @printf("%+3.1f      %+.8f (%+.8f) %+.8f (%+.8f)\n",
           θr, sinθ, sinθ - sin(θr), cosθ, cosθ - cos(θr))
    end

end

test_cordic()
