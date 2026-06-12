#=
Exhaustive search for complete railway (railroad track) circuits. A valid circuit begins and ends at the
same point faciing in the same direction. Track are either right handed or left handed 30 degree
curves or are straight track that can be placed at -90, 0, or 90 degree angles from starting points.

Turns are defined by 1 for right turn, -1 for left turn, 0 for no turn (0 only with straight track)

Equivalent circuits are all in the same equivalence group, as follows:

The equivalence group of rotational (circular) permutations of the turns vector in product with the
complementation (scalar multiplication by -1) of those turns determines the equivalence group
for a turns vector.

So, the equivalence group is composed: (rotational permutations) X (scalar multiplication by -1)

There is another factor in equivalence groups not mentioned in the task as of June 2022: __vector reversal__.
If __vector reversal__ is included, (1 -1 1 1 1 -1 -1) is considered to group with (-1 -1 1 1 1 -1 1).

Furthermore, if chosen, reversal of the turns vector (not mentioned as a source of symmetry in the task)
is also multiplied in for a larger equivalence group:

(rotational permutations) X (scalar multiplication by -1) X (vector reversal)

Each unique and valid turn vector is chosen to be the maximum vector in its
equivalence group. All turns vectors must represent a closed path ending in a direction
identical to (mod 2π radians from) its initial vector direction on the plane.

Time required for an N turns solution is O(2^N) for curved track and O(3^N) for straight track.

Graphic displays of solutions are via a Gtk app and Cairo graphics.
=#
""" Rosetta Code task rosettacode.org/wiki/Railway_circuit. """

using Gtk, Cairo

""" Point is a 2D point in the plane: type T can be Float64 for this usage """
struct Point{T}
    x::T
    y::T
end

""" add Points as vectors on plane """
Base.:+(p::Point, q::Point) = Point(p.x + q.x, p.y + q.y)

""" Tracks align if within absolute tolerance of 1 in 100 (with radius of curvature 1) """
Base.:≈(p::Point, q::Point) =
    isapprox(p.x, q.x, atol = 0.01) && isapprox(p.y, q.y, atol = 0.01)

""" a curve section 30 degrees is 1/12 of a circle angle or π/6 radians """
const twelvesteps = [Point(sinpi(a / 6), cospi(a / 6)) for a = 1:12]

""" a straight section 90 degree angle is 1/4 of a circle angle or π/2 radians """
const foursteps = [Point(sinpi(a / 2), cospi(a / 2)) for a = 1:4]

""" Determine if vector `turns` is in an equivalence group with the vector `groupmember` """
function isinequivalencegroup(turns, groupmember, reversals = false)
    for i in eachindex(turns)
        groupmember == circshift(turns, i - 1) && return true
    end
    invturns = -1 .* turns
    for i in eachindex(invturns)
        groupmember == circshift(invturns, i - 1) && return true
    end
    if reversals
        revturns = reverse(turns)
        for i in eachindex(revturns)
            groupmember == circshift(revturns, i - 1) && return true
        end
        invturns = -1 .* revturns
        for i in eachindex(invturns)
            groupmember == circshift(invturns, i - 1) && return true
        end
    end
    return false
end

""" get the maximum member of the equivalence group containing vector turns """
function maximumofsymmetries(turns, groupsfound, reversals = false)
    maxofgroup = turns
    for i in eachindex(turns)
        t = circshift(turns, i - 1)
        push!(groupsfound, t)
        if t > maxofgroup
            maxofgroup = t
        end
    end
    invturns = -1 .* turns
    for i in eachindex(invturns)
        t = circshift(invturns, i - 1)
        push!(groupsfound, t)
        if t > maxofgroup
            maxofgroup = t
        end
    end
    if reversals # [1 -1 1 1] => [1 1 -1 1]
        revturns = reverse(turns)
        for i in eachindex(revturns)
            t = circshift(revturns, i - 1)
            push!(groupsfound, t)
            if t > maxofgroup
                maxofgroup = t
            end
        end
        revinvturns = -1 .* revturns
        for i in eachindex(revinvturns)
            t = circshift(revinvturns, i - 1)
            push!(groupsfound, t)
            if t > maxofgroup
                maxofgroup = t
            end
        end
    end
    return maxofgroup
end

""" Returns true if the path of turns returns to starting point, and on that return is
    moving in a direction opposite to the starting direction.
"""
function isclosedpath(turns, straight, start = Point(0.0, 0.0))
    if sum(turns) % (straight ? 4 : 12) != 0 # turns angle sum must be a multiple of 2π
        return false
    end
    angl, point = 0, start
    if straight
        for turn in turns
            angl += turn
            point += foursteps[mod1(angl, 4)]
        end
    else
        for turn in turns
            angl += turn
            point += twelvesteps[mod1(angl, 12)]
        end
    end
    return point ≈ start
end

""" Draw the curves found, display on a Gtk canvas. """
function RailroadLayoutApp(turnsarray, savefilename; straight = false, reversals = false)
    win = GtkWindow("Showing $(length(turnsarray)) circuits with $(length(turnsarray[1])) turns ($(reversals ? "excl" : "incl")uding reversed curves)",
       720, 1000) |> (can = GtkCanvas())
    set_gtk_property!(can, :expand, true)

    @guarded draw(can) do widget
        ctx = getgc(can)
        h, w = height(can), width(can)
        r = (w + h) / 96
        nsquares = length(turnsarray[1])
        gridx = isqrt(nsquares)
        gridy = (nsquares + gridx - 1) ÷ gridx
        x0, y0, = 6r, 6r
        for (i, turns) in enumerate(turnsarray)
            x, y = x0 + 6 * r * (i % gridx), y0 + 6 * r * ((i - 1) ÷ gridx)
            angle = 0
            if straight
                for turn in turns
                    # black dot at layout track segment start point
                    set_source_rgb(ctx, 0, 0, 0)
                    arc(ctx, x, y, 2, 0, 2π)
                    fill(ctx)
                    # red line segment for track
                    set_source_rgb(ctx, 255, 0, 0)
                    angle += turn * π/2
                    newx, newy = x + r * cos(angle), y + r * sin(angle)
                    move_to(ctx, x, y)
                    line_to(ctx, newx, newy)
                    x, y = newx, newy
                    stroke(ctx)
                end
            else
                for turn in turns
                    # black dot at layout track segment start point
                    set_source_rgb(ctx, 0, 0, 0)
                    arc(ctx, x, y, 2, 0, 2π)
                    fill(ctx)
                    # bluegreen dot at center of radius of curvature
                    set_source_rgb(ctx, 0, 120, 180)
                    centerangle = (-angle - turn * π/2) % 2π
                    centerx, centery = x - r * cos(centerangle), y - r * sin(centerangle)
                    arc(ctx, centerx, centery, 2, 0, 2π)
                    fill(ctx)
                    # red curve for track
                    set_source_rgb(ctx, 255, 0, 0)
                    centerangle2 = (centerangle + turn * π/6) % 2π
                    a1, a2 = min(centerangle, centerangle2), max(centerangle, centerangle2)
                    if a2 - a1 > π
                        a1, a2 = a2, a1
                    end
                    arc(ctx, centerx, centery, r, a1, a2)
                    stroke(ctx)
                    # compute x and y of next start point (endppoint of curve just drawn)
                    x, y = centerx + r * cos(centerangle2), centery + r * sin(centerangle2)
                    # compute next starting angle
                    angle -= turn * π/6
                end
            end
        end
    end
    showall(win)
end

"""
function allvalidcircuits(N; verbose = false, straight = false, reversals = true, graphic = true)

Count the complete circuits by their equivalence groups. Show the unique highest sorting vectors
from each equivalence group if verbose. Use 30 degree curved track if straight is false, otherwise
straight track. Allow reversed circuits if otherwise in another grouup if reversals is false,
otherwise do not consider reversed order vectors unique. Show graphic representation of the unique
paths if graphic is true.
"""
function allvalidcircuits(N; verbose = false, straight = false, reversals = false, graphic = false)
    found = Vector{Vector{Int}}()
    groupmembersfound = Set{Vector{Int}}()
    println("\nFor N of $N and ", straight ? "straight" : "curved", " track, $(reversals ? "excl" : "incl")uding reversed curves: ")
    for i in (straight ? (0:3^N-1) : (0:2^N-1))
        turns =
            straight ?
            [d == 0 ? 0 : (d == 1 ? 1 : -1) for d in digits(i, base = 3, pad = N)] :
            [d == 0 ? 1 : -1 for d in digits(i, base = 2, pad = N)]
        if isclosedpath(turns, straight) && !(turns in groupmembersfound)
            if length(found) == 0 || all(t -> !isinequivalencegroup(turns, t), found)
                canon = maximumofsymmetries(turns, groupmembersfound, reversals)
                verbose && println(canon)
                push!(found, canon)
            end
        end
    end
    println("Found $(length(found)) unique valid circuits.")
    graphic && @async begin RailroadLayoutApp(deepcopy(found), "N$N.png"; reversals = reversals) end
    return found
end

# Note 4:2:36 takes a long time, for shorter runs do 4:4:24 here for i
for i = 4:2:36, rev in false:true, str in false:true
    str && i > 16 && continue
    @time allvalidcircuits(i; verbose = !str && i < 28, reversals = rev, straight = str, graphic = i == 24)
end
