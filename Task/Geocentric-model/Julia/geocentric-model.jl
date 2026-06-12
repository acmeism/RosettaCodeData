using Colors
using Luxor

# Drawing rectangle dimensions: not the same as ultimate movie screen size
const WIDTH  = 3000
const HEIGHT = 3000

""" Planet data: name, semi-major axis (scaled), orbital speed, size, color, eccentricity
    - semi-major axis is scaled down from real AU to fit in the window
    - orbital speed is a relative value to control animation speed
    - size is a visual representation of the planet's size (NOT to scale)
    - color is chosen for visual distinction
    - eccentricity is used to calculate the shape of the (slightly elliptical) orbits
"""
mutable struct PlanetData
    name::String
    a::Float64
    speed::Float64
    size::Float64
    color::Colorant
    eccentricity::Float64
end

"""
    The a parameter has been scaled by sqrt from real AU to fit in the window, so that the
    outer planets don't go off-screen. The eccentricity values are exaggerated for better
    visual effect. The orbital speeds are relative and chosen to make the animation visually
    appealing, not to scale. The sizes of the planets are also not to scale, but chosen to
    make them visible and distinguishable in the animation. In reality, the size difference
    between the Sun and the planets is much more extreme, and the planets themselves vary
    greatly in size. Here, we use a more uniform size range to ensure that all planets are
    visible and recognizable in the animation, while still giving a sense of their relative
    sizes. The eccentricity values are also exaggerated to make the elliptical orbits more
    visually distinct, as the real eccentricities of most planets are quite small and would
    appear almost circular in the animation.
"""
const PLANET_DATA = [
    PlanetData("Mercury",  795, 0.020,  3, colorant"gray",       0.205),
    PlanetData("Venus",   1085, 0.015,  7, colorant"gold",       0.007),
    PlanetData("Earth",   1275, 0.012,  8, colorant"blue",       0.017),
    PlanetData("Mars",    1575, 0.010,  4, colorant"red",        0.093),
    PlanetData("Jupiter", 2910, 0.007, 90, colorant"orange",     0.048),
    PlanetData("Saturn",  3940, 0.006, 58, colorant"khaki",      0.056),
    PlanetData("Uranus",  5590, 0.004, 32, colorant"aquamarine", 0.047),
    PlanetData("Neptune", 7000, 0.003, 31, colorant"royalblue",  0.009),
    PlanetData("Sun",        0, 0.0,  120, colorant"orangered",  0.000),
    PlanetData("Moon",     120, 0.040,  2, colorant"silver",     0.055),
]

# scale down the semi-major axes to fit in the window
for i in eachindex(PLANET_DATA)
    PLANET_DATA[i].a *= 0.2
end

# orbit color
const ORBIT_COLOR = "gray40"

# time variable is a Ref so it can be modified for each frame! function drawplanets() call
const T = Ref(0.0)

""" Solve Kepler equation via Newton iteration """
function kepler(M, e)
    E = M
    for _ in 1:8 # 8 iterations should be enough for convergence
        E -= (E - e * sin(E) - M) / (1 - e * cos(E))
    end
    return E
end

""" Draw planets and their orbits """
function drawplanets()
    setline(5)
    earthpx, earthpy = 0.0, 0.0

    for planet in PLANET_DATA
        name = planet.name
        a = planet.a
        speed = planet.speed
        size = planet.size
        color = planet.color
        e = planet.eccentricity
        if name == "Sun" # no orbital motion for the Sun
            px = 0.0
            py = 0.0

        elseif name == "Moon" # Moon orbits Earth, not the Sun
            b = a * sqrt(1 - e^2)
            M = T[] * speed
            E = kepler(M, e)
            x = a * (cos(E) - e)
            y = b * sin(E)
            px = earthpx + x
            py = earthpy + y
            setcolor(ORBIT_COLOR)
            ellipse(Point(earthpx - a * e, earthpy), 2a, 2b, action= :stroke)

        else # planets orbit the Sun
            b = a * sqrt(1 - e^2)
            M = T[] * speed
            E = kepler(M, e)
            x = a * (cos(E) - e)
            y = b * sin(E)
            px = x
            py = y
            setcolor(ORBIT_COLOR)
            ellipse(Point(-a * e, 0), 2a, 2b, action= :stroke)
            if name == "Earth" # set up for Moon's orbit
                earthpx = px
                earthpy = py
            end
        end

        setcolor(color)
        circle(Point(px, py), size, action = :fill)

        setcolor("white")
        fontface("Georgia")
        fontsize(20)
        text(name, Point(px + size + 10, py))
    end
end

# Create the movie with its chosen filename
const SOLAR_SYSTEM = Movie(WIDTH, HEIGHT, "PlanetSimulation.mp4")

""" draw the static animation background """
backdrop!(scene, framenumber) = background("gray9")

""" Update the time variable T for each frame and redraw the planets and orbits """
function frame!(scene, framenumber)
    T[] = 0.5 * framenumber  # Adjust this to change the speed of revolution
    drawplanets()
end

# Create the animation by combining the backdrop and frame scenes, and save it as a movie.
# The backdrop is static, while the frame scene updates the planet positions for each frame.
# Note: Luxor should create a temp directory for each movie. If you run this code multiple
# times, you may want to clean up those temp directories to save disk space.
animate(SOLAR_SYSTEM, [
    Scene(SOLAR_SYSTEM, backdrop!, 0:120),
    Scene(SOLAR_SYSTEM, frame!, 0:900),
], createmovie = true)
