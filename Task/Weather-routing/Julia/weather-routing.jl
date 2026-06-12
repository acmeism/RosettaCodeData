module SailingPolars

using DelimitedFiles

export SailingPolar, SurfaceParameters, getpolardata, deg2rad, rad2deg, cartesian2polar
export polar2cartesian, haversine, inverse_haversine, boatspeed, bestvectorspeed
export sailingspeed, sailsegmenttime

"""
    Structure to represent a polar CSV file's data.

Contains a matrix, speeds, of sailing speeds indexed by wind velocity and angle of boat to wind
winds is a list of wind speeds
degrees is a list of angles in degrees of direction relative to the wind
Note 0.0 degrees is directly into the wind, 180 degrees is directly downwind.
"""
struct SailingPolar
    winds::Vector{Float32}
    degrees::Vector{Float32}
    speeds::Matrix{Float32} # speeds[wind direction degrees, windspeed knots]
end

"""
    struct SurfaceParameters

Structure that represents wind and surface current direction and velocity for a given position
Angles in degrees, velocities in knots
"""
struct SurfaceParameters
    winddeg::Float32
    windkts::Float32
    currentdeg::Float32
    currentkts::Float32
end

"""
function getpolardata(filename)

Read a sailing polar CSV file and return a SailingPolar containing the file data.

A sailing polar file is a CSV file, with ';' used as the comma separator instead of a comma.
The first line of file contains labels for the wind velocities that make up columns, and
the first entry of each row makes up a column of angle of sailing direction from wind in degrees
"""
function getpolardata(filename)
    datacells, headercells = readdlm(filename, ';', header=true)
    winds = map(x -> parse(Float32, x), headercells[2:end])
    degrees = datacells[:, 1]
    speeds = datacells[:, 2:end]
    return SailingPolar(winds, degrees, speeds)
end


const R = 6372800  # Earth's approximate radius in meters

"""
    deg2rad(deg)

Convert degrees to radians
"""
deg2rad(deg) = (deg * π / 180.0 + 2π) % 2π

"""
    rad2deg(rad)

Convert radians to degrees
"""
rad2deg(rad) = (rad * (180.0 / π) + 360.0) % 360.0

"""
    cartesian2polard(x, y)

Convert x, y coordinates to polar coordinates with angle in degrees
"""
cartesian2polard(x, y) = sqrt(x * x + y * y), atand(x, y)

"""
    polard2cartesian(r, deg)

Convert polar coordinates in degrees to cartesian x, y coordinates
"""
polard2cartesian(r, deg) = r .* sincosd(deg)

"""
    function haversine(lat1, lon1, lat2, lon2)

Calculate the haversine function for two points on the Earth's surface.

Given two latitude, longitude pairs in degrees for a point on the Earth,
get distance in meters and the initial direction of travel in degrees for
movement from point 1 to point 2.
"""
function haversine(lat1, lon1, lat2, lon2)
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = sind(dlat / 2)^2 + cosd(lat1) * cosd(lat2) * sind(dlon / 2)^2
    c = 2.0 * asind(sqrt(a))
    theta = atand(sind(dlon) * cosd(lat2),
        cosd(lat1) * sind(lat2) - sind(lat1) * cosd(lat2) * cosd(dlon))
    theta = (theta + 360) % 360
    return R * c * 0.5399565, theta
end

"""
    function inverse_haversine(lat1, lon1, distance, direction)

Calculate an inverse haversine function.

Takes the point of origin in degrees (latitude, longitude), distance in meters, and
initial direction in degrees, and returns the latitude and longitude of the endpoint
in degrees after traveling the specified distance.
"""
function inverse_haversine(lat1, lon1, distance, direction)
    lat2 = asind(sind(lat1) * cos(distance / R) + cosd(lat1) * sin(distance / R) * cosd(direction))
    lon2 = lon1 + atand(sind(direction) * sin(distance / R) * cosd(lat1),
                       cos(distance / R) - sind(lat1) * sind(lat2))
    return lat2, lon2
end

"""
    function boatspeed(sp::SailingPolar, pointofsail, windspeed)

Calculate the expected sailing speed in a specified direction in knots,
given sailing polar data, a desired point of sail in degrees, and wind speed in knots
"""
function boatspeed(sp::SailingPolar, pointofsail, windspeed)
    winds, degrees, speeds = sp.winds, sp.degrees, sp.speeds
    udeg = findlast(t -> t <= pointofsail, degrees)
    odeg = findfirst(t -> t >= pointofsail, degrees)
    uvel = findlast(t -> t <= windspeed, winds)
    ovel = findfirst(t -> t >= windspeed, winds)
    if any(t -> t == nothing, [udeg, odeg, uvel, ovel])
        return -1.0
    end
    frac = (odeg == udeg && uvel == ovel) ? 1.0 :
            (odeg == udeg) ? (windspeed - winds[uvel]) / (winds[ovel] - winds[uvel]) :
            (uvel == ovel) ? (pointofsail - degrees[udeg]) / (degrees[odeg] - degrees[udeg]) :
            ((pointofsail - degrees[udeg]) / (degrees[odeg] - degrees[udeg]) +
            (windspeed - winds[uvel]) / (winds[ovel] - winds[uvel])) / 2
    return speeds[udeg, uvel] + frac * (speeds[odeg, ovel] - speeds[udeg, uvel])
end


"""
    sailingspeed(sp::SailingPolar, azimuth, pointos, ws)

Calculate the expected net boat speed in a desired direction versus the wind (azimuth).
This is generally different from the actual boat speed in its actual direction.
Directions are in degrees (pointos is point of sail, the ship direction from wind),
and velocity of wind (ws) is in knots.
"""
sailingspeed(sp, azimuth, pointos, ws) = boatspeed(sp, pointos, ws) * cosd(abs(pointos - azimuth))


"""
    function bestvectorspeed(sp::SailingPolar, dirtravel, dirwind, windspeed, dircur, velcur)

Calculate the net direction and velocity of a sailing ship.

Arguments are sailing polar data, direction of travel in degrees from north, wind direction in
degrees from north, wind velocity in knots, surface current direction in degrees, and
current velocity in knots.
"""
function bestvectorspeed(sp::SailingPolar, dirtravel, dirwind, windspeed, dircur, velcur)
    azimuth = (dirtravel - dirwind) % 360.0
    azimuth = azimuth < 0 ? azimuth + 360.0 : azimuth
    azimuth = azimuth > 180.0 ? 360.0 - azimuth : azimuth
    VMG = boatspeed(sp, azimuth, windspeed)
    other, idx = findmax([sailingspeed(sp, azimuth, x, windspeed) for x in sp.degrees])
    if other > VMG
        azimuth = sp.degrees[idx]
        VMG = other
    end
    dirchosen = deg2rad(dirwind + azimuth)
    wx, wy = VMG * sin(dirchosen), VMG * cos(dirchosen)
    curx, cury = velcur * sin(deg2rad(dircur)), velcur * cos(deg2rad(dircur))
    return rad2deg(atan(wy + cury, wx + curx)), sqrt((wx + curx)^2 + (wy + cury)^2)
end

"""
    function sailsegmenttime(sp::SailingPolar, p::SurfaceParameters, lat1, lon1, lat2, lon2)

Calculate the trip time in minutes from (lat1, lon1) to the destination (lat2, lon2).
Uses the data in SurfaceParameters for wind and current velocity and direction.
"""
function sailsegmenttime(sp::SailingPolar, p::SurfaceParameters, lat1, lon1, lat2, lon2)
    distance, dir = haversine(lat1, lon1, lat2, lon2)
    dir2, vel = bestvectorspeed(sp, dir, p.winddeg, p.windkts, p.currentdeg, p.currentkts)
    # minutes/s * m / (knots * (m/s / knot)) = minutes
    return (1 / 60) * distance / (vel * 1.94384)
end


end # module


module SailingNavigation

export Position, lat, lon, GridPoint, TimeSlice, TimedPath, closestpoint, surround
export RoutingProblem, minimumtimeroute

using GeometryTypes
using ..SailingPolars

# NB: This uses latitude (often considered to be y) first then longitude (often considered to be x).
# This latitude, then longitude ordering is as per ISO 6709 (en.wikipedia.org/wiki/ISO_6709)

# Position is a Float32 2-tuple of latitude and longitude in degrees
Position = Point2f0

# latitude from Position
lat(p::Position) = p[1]

# longitude from Position
lon(p::Position) = p[2]

# A GridPoint is a Position with the SurfaceParameters of wind and current at the Position
mutable struct GridPoint
    pt::Position
    sp::SurfaceParameters
end

"""
    TimeSlice

A TimeSlice is a matrix of GridPoints, each Position point with their SurfaceParameters
A Vector of TimeSlice can give the surface characteristics for an ocean region over time.
"""
TimeSlice = Matrix{GridPoint}

"""
    mutable struct RoutingProblem

timeinterval: the minutes duration for each TimeSlice
timeframe: a vector of sequential timeslices for the ocean region
obstacleindices: the Cartesian indices in each timeslice for
    obstacles, such as land or shoals, where the ship may not go
startindex: the timeslice position for time of starting
start: starting location on grid of GridPoints
finish: destination / finish location on grid of GridPoints
allowrepeatvisits: whether the vessel may overlap its prior path, usually false
"""
mutable struct RoutingProblem
    timeinterval::Float64 # minutes between timeframe slices
    timeframe::Vector{TimeSlice}
    obstacleindices::Vector{Point2{Int}}
    startindex::Int
    start::Point2{Int}
    finish::Point2{Int}
    allowrepeatvisits::Bool
end

"""
    mutable struct TimedPath

duration: minutes total to travel the path
path: vector of Cartesian indices of points in grid for path to travel
"""
mutable struct TimedPath
    duration::Float64
    path::Vector{Point2{Int}}
end

"""
    closestpoint(p, mat)

Get the closest GridPoint in matrix mat to a given position p.
p: Cartesian indices of a Position (latitude, longitude in degrees) in grid of GridPoints
mat: matrix of Gridpoints
"""
closestpoint(p, mat) = findmin(gp -> haversine(p[1], p[2], gp.pt[1], gp.pt[2])[1], mat)[2]

function surround(p, mat, excluded)
    neighbors = Point2{Int}[(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    (xmax, ymax) = size(mat)
    return filter(q -> 1 <= q[1] <= xmax && 1 <= q[2] <= ymax && !(q in excluded),
        [x + p for x in neighbors])
end

"""
    function minimumtimeroute(rp::RoutingProblem, sp::SailingPolar, verbose=false)

Get the route (as a TimedPath) that minimizes time from start to finish for a given
RoutingProblem (sea parameters) given sailing polar data (ship parameters).
"""
function minimumtimeroute(rp::RoutingProblem, sp::SailingPolar, verbose=false)
    timedpaths = [TimedPath(0.0, [rp.start])]
    completed, mintime, minpath = false, 1000.0, TimedPath(1000.0, [])
    for i in 1:1000
        newpaths = TimedPath[]
        verbose && println("Checking ", length(timedpaths), " paths of length ",
            length(timedpaths[1].path) - 1)
        for tpath in timedpaths
            if tpath.path[end] == rp.finish
                completed = true
                push!(newpaths, tpath)
            else
                p1 = tpath.path[end]
                slice = rp.timeframe[div(Int(round(tpath.duration)),
                                     Int(round(rp.timeinterval))) %
                                     length(rp.timeframe) + 1]
                for p2 in surround([p1[1], p1[2]], slice, rp.obstacleindices)
                    !rp.allowrepeatvisits && p2 in tpath.path && continue
                    gp1, gp2 = slice[p1[1], p1[2]], slice[p2[1], p2[2]]
                    lat1, lon1, lat2, lon2 = gp1.pt[1], gp1.pt[2], gp2.pt[1], gp2.pt[2]
                    t = sailsegmenttime(sp, gp1.sp, lat1, lon1, lat2, lon2)
                    path = deepcopy(tpath.path)
                    push!(path, p2)
                    push!(newpaths, TimedPath(tpath.duration + t, path))
                end
            end
        end
        timedpaths = unique(newpaths)
        if completed
            mindur = minimum(map(x -> x.duration, timedpaths))
            finished = filter(x -> x.path[end] == rp.finish, timedpaths)
            minfindur, idx = findmin(map(x -> x.duration, finished))
            verbose && println("Current finished minimum: ", finished[idx], ", others $mindur")
            if mindur == minfindur
                minpath = finished[idx]
                break
            end
        end
    end
    return minpath
end

end # module

using GeometryTypes
using .SailingNavigation, .SailingPolars

#=
The data is selected so the best time path is slightly longer than the
shortest length path. The forbidden regions are x, representing land or reef.
The allowed sailing points are . and start and finish are S and F.

x  .  .  F  .  .  x  .  x
.  .  .  .  .  .  .  x  x
x  .  .  x  x  x  .  .  .
.  .  x  x  x  x  .  x  x
x  .  .  .  x  x  .  x  .
x  .  .  .  x  x  .  x  .
.  .  .  .  x  .  .  x  .
x  .  .  .  .  .  .  x  .
.  .  .  S  .  .  .  .  .
=#
const forbidden = Point2{Int}.([
    [1, 8], [2, 1], [2, 8], [3, 5], [3, 8], [4, 1], [4, 5], [4, 6], [4, 8], [5, 1],
    [5, 5], [5, 6], [5, 8], [6, 3], [6, 4], [6, 5], [6, 6], [6, 8], [6, 9], [7, 1],
    [7, 4], [7, 5], [7, 6], [8, 8], [8, 9], [9, 1], [9, 7], [9, 9],
])

# Create regional wind patterns on the map.
function surfacebylongitude(lon)
    return lon < -155.03 ? SurfaceParameters(-5.0, 8, 150, 0.5) :
           lon < -155.99 ? SurfaceParameters(-90.0, 20, 150, 0.4) :
                           SurfaceParameters(180.0, 25, 150, 0.3)
end

# Vary wind speeds over time.
function mutatetimeslices!(slices)
    for (i, slice) in enumerate(slices), x in slice
        x.sp = SurfaceParameters(x.sp.winddeg, x.sp.windkts * (1 + 0.002 * i),
            x.sp.currentdeg, x.sp.currentkts)
    end
end


const startpos = Point2{Int}(1, 4)
const endpos = Point2{Int}(9, 4)
const pmat  = [Position(19.78 - 1/60 + i/60, -155.0 - 5/60 + j/60) for i in 0:8, j in 0:8]
const gpoints = map(pt -> GridPoint(pt, surfacebylongitude(lon(pt))), pmat)
const slices = [deepcopy(gpoints) for _ in 1:200]
mutatetimeslices!(slices)

const routeprob = RoutingProblem(10.0, slices, forbidden, 1, startpos, endpos, false)
const filename = "polar.csv"
const sp = getpolardata(filename)
const tp = minimumtimeroute(routeprob, sp)

println("The route taking the least time found was:\n    ", tp.path,
    "\nwhich has duration $(div(tp.duration, 60)) hours, $(rem(tp.duration, 60)) minutes.")
