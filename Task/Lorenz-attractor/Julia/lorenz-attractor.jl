using Colors
using Luxor

const SIGMA = 10.0
const RHO   = 28.0
const BETA  = 8.0 / 3.0
const STEP_DT = 0.01

mutable struct LorenzAttractor
    x::Float64
    y::Float64
    z::Float64
    points::Vector{Point}
    LorenzAttractor(x = 0.01, y = 0.0, z = 0.0) = new(x, y, z, Point[])
end

function step!(lorenz::LorenzAttractor, dt::Float64 = STEP_DT)
    # Euler integration
    lorenz.x += (SIGMA * (lorenz.y - lorenz.x)) * dt
    lorenz.y += (lorenz.x * (RHO - lorenz.z) - lorenz.y) * dt
    lorenz.z += (lorenz.x * lorenz.y - BETA * lorenz.z) * dt
    push!(lorenz.points, Point(lorenz.x * 10, lorenz.y * 10))
    length(lorenz.points) > 2000 && popfirst!(lorenz.points)
end

function draw_lorenz(lorenz)
    background("black")
    sethue("magenta")
    pts = lorenz.points
    if length(pts) >= 2
        poly(pts, :stroke)
    end
end

function makelorenz()
    lorenz = LorenzAttractor()
    movie = Movie(800, 600, "lorenz")

    function frame(scene, framenumber)
        # advance simulation 10 steps per frame
        for _ in 1:10
            step!(lorenz)
        end
        draw_lorenz(lorenz)
        framenumber % 20 == 0 && println("Frame $framenumber: x=$(lorenz.x), y=$(lorenz.y), z=$(lorenz.z)")
    end

    animate(movie, [Scene(movie, frame, 1:200)], creategif=true, pathname="lorenz.gif")
end

makelorenz()
