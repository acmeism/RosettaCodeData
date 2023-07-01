# Run from Julia REPL to see the plots.
using Statistics, Distributions, Plots

const racket_xdata = [-0.533, 0.270, 0.859, -0.043, -0.205, -0.127, -0.071, 0.275, 1.251, -0.231,
        -0.401, 0.269, 0.491, 0.951, 1.150, 0.001, -0.382, 0.161, 0.915, 2.080, -2.337,
         0.034, -0.126, 0.014, 0.709, 0.129, -1.093, -0.483, -1.193, 0.020, -0.051,
         0.047, -0.095, 0.695, 0.340, -0.182, 0.287, 0.213, -0.423, -0.021, -0.134, 1.798,
         0.021, -1.099, -0.361, 1.636, -1.134, 1.315, 0.201, 0.034, 0.097, -0.170, 0.054,
        -0.553, -0.024, -0.181, -0.700, -0.361, -0.789, 0.279, -0.174, -0.009, -0.323,
        -0.658, 0.348, -0.528, 0.881, 0.021, -0.853, 0.157, 0.648, 1.774, -1.043, 0.051,
         0.021, 0.247, -0.310, 0.171, 0.000, 0.106, 0.024, -0.386, 0.962, 0.765, -0.125,
        -0.289, 0.521, 0.017, 0.281, -0.749, -0.149, -2.436, -0.909, 0.394, -0.113, -0.598,
         0.443, -0.521, -0.799, 0.087]

const racket_ydata = [0.136, 0.717, 0.459, -0.225, 1.392, 0.385, 0.121, -0.395, 0.490, -0.682, -0.065,
        0.242, -0.288, 0.658, 0.459, 0.000, 0.426, 0.205, -0.765, -2.188, -0.742, -0.010,
        0.089, 0.208, 0.585, 0.633, -0.444, -0.351, -1.087, 0.199, 0.701, 0.096, -0.025,
        -0.868, 1.051, 0.157, 0.216, 0.162, 0.249, -0.007, 0.009, 0.508, -0.790, 0.723,
        0.881, -0.508, 0.393, -0.226, 0.710, 0.038, -0.217, 0.831, 0.480, 0.407, 0.447,
        -0.295, 1.126, 0.380, 0.549, -0.445, -0.046, 0.428, -0.074, 0.217, -0.822, 0.491,
        1.347, -0.141, 1.230, -0.044, 0.079, 0.219, 0.698, 0.275, 0.056, 0.031, 0.421, 0.064,
        0.721, 0.104, -0.729, 0.650, -1.103, 0.154, -1.720, 0.051, -0.385, 0.477, 1.537,
        -0.901, 0.939, -0.411, 0.341, -0.411, 0.106, 0.224, -0.947, -1.424, -0.542, -1.032]

const rules = [(x, y, dx, dy) -> [0, 0], (x, y, dx, dy) -> [-dx, -dy],
         (x, y, dx, dy) -> [-x - dx, -y - dy], (x, y, dx, dy) -> [x + dx, y + dy]]
const plots, colors = plot(layout=(1,2)), [:red, :green, :blue, :yellow]

function makedata()
    radius_angles = zip(rand(Normal(), 100), rand(Uniform(-π, π), 100))
    zip([z[1] * cos(z[2]) for z in radius_angles], [z[1] * sin(z[2]) for z in radius_angles])
end

function testfunnel(useracket=true)
    for (i, rule) in enumerate(rules)
        origin = [0.0, 0.0]
        xvec, yvec = Float64[], Float64[]
        for point in (useracket ? zip(racket_xdata, racket_ydata) : makedata())
            push!(xvec, origin[1] + point[1])
            push!(yvec, origin[2] + point[2])
            origin .= rule(origin[1], origin[2], point[1], point[2])
        end
        println("Rule $i results:")
        println("mean x: ", round(mean(xvec), digits=4), " std x: ", round(std(xvec, corrected=false), digits=4),
            " mean y: ", round(mean(yvec), digits=4), " std y: ", round(std(yvec, corrected=false), digits=4))
        scatter!(xvec, yvec, color=colors[i], subplot=(useracket ? 1 : 2),
            title= useracket ? "Racket Data" : "Random Data", label="Rule $i")
    end
end

println("\nUsing Racket data.")
testfunnel()
println("\nUsing new data.")
testfunnel(false)
display(plots)
