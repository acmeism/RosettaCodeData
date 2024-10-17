using Makie, Statistics

# Point3f0 is a 3-tuple of 32-bit floats for 3-dimensional space, and all Points are 3D.
Point = Point3f0

# a Face is defined by the points that are its vertices, in order.
Face = Vector{Point}

# an Edge is a line segment where the points are sorted
struct Edge
    p1::Point
    p2::Point
    Edge(a, b) = new(min(a, b), max(a, b))
end

edgemidpoint(edge) = (edge.p1  + edge.p2) / 2.0
facesforpoint(p, faces) = [f for f in faces if p in f]
facesforedge(e, faces) = [f for f in faces if (e.p1 in f) && (e.p2 in f)]
nexttohole(edge, faces) = length(facesforedge(edge, faces)) < 2

function newedgepoint(edge, faces)
    f = facesforedge(edge, faces)
    p1, p2, len = edge.p1, edge.p2, length(f)
    if len == 2
        return (p1 + p2 + mean(f[1]) + mean(f[2])) / 4.0
    elseif len == 1
        return (p1 + p2 + mean(f[1])) / 3.0
    end
    return (p1 + p2) / 2.0
end

function edgesforface(face)
    ret, indices = Vector{Edge}(), collect(1:length(face))
    for i in 1:length(face)-1
        push!(ret, Edge(face[indices[1]], face[indices[2]]))
        indices .= circshift(indices, 1)
    end
    ret
end

function edgesforpoint(p, faces)
    f = filter(x -> p in x, faces)
    return filter(e -> p == e.p1 || p == e.p2, mapreduce(edgesforface, vcat, f))
end

function adjacentpoints(point, face)
    a = indexin([point], face)
    if a[1] != nothing
        adjacent = (a[1] == 1) ? [face[end], face[2]] :
            a[1] == length(face) ? [face[end-1], face[1]] :
            [face[a[1] - 1], face[a[1] + 1]]
        return sort(adjacent)
    else
        throw("point $point not in face $face")
    end
end

adjacentedges(point, face) = [Edge(point, x) for x in adjacentpoints(point, face)]
facewrapped(face) = begin f = deepcopy(face); push!(f, f[1]); f end
drawface(face, colr) = lines(facewrapped(face); color=colr)
drawface!(face, colr) = lines!(facewrapped(face); color=colr)
drawfaces!(faces, colr) = for f in faces drawface!(f, colr) end
const colors = [:red, :green, :blue, :gold]

function drawfaces(faces, colr)
    scene = drawface(faces[1], colr)
    if length(faces) > 1
        for f in faces[2:end]
            drawface!(f, colr)
        end
    end
    scene
end

function catmullclarkstep(faces)
    d, E, dprime = Set(reduce(vcat, faces)), Dict{Vector, Point}(), Dict{Point, Point}()
    for face in faces, (i, p) in enumerate(face)
        edge = (p == face[end]) ? Edge(p, face[1]) : Edge(p, face[i + 1])
        E[[edge, face]] = newedgepoint(edge, faces)
    end
    for p in d
        F = mean([mean(face) for face in facesforpoint(p, faces)])
        pe = edgesforpoint(p, faces)
        R = mean(map(edgemidpoint, pe))
        n = length(pe)
        dprime[p] = (F + 2 * R + p * (n - 3)) / n
    end
    newfaces = Vector{Face}()
    for face in faces
        v = mean(face)
        for point in face
            fp1, fp2 = map(x -> E[[x, face]], adjacentedges(point, face))
            push!(newfaces, [fp1, dprime[point], fp2, v])
        end
    end
    return newfaces
end

"""
    catmullclark(faces, iters, scene)

Perform a multistep Catmull-Clark subdivision of a surface. See Wikipedia or page 53
of http://graphics.stanford.edu/courses/cs468-10-fall/LectureSlides/10_Subdivision.pdf
Plots the iterations, with colors for each iteration as set in the colors array.
Uses a Makie Scene of scene to plot the iters iterations.
"""
function catmullclark(faces, iters, scene)
    nextfaces = deepcopy(faces)
    for i in 1:iters
        nextfaces = catmullclarkstep(nextfaces)
        drawfaces!(nextfaces, colors[i])
        display(scene)
        sleep(1)
    end
end

const inputpoints = [
    [-1.0, -1.0, -1.0],
    [-1.0, -1.0, 1.0],
    [-1.0, 1.0, -1.0],
    [-1.0, 1.0, 1.0],
    [1.0, -1.0, -1.0],
    [1.0, -1.0, 1.0],
    [1.0, 1.0, -1.0],
    [1.0, 1.0, 1.0]
]

const inputfaces = [
    [0, 4, 5, 1],
    [4, 6, 7, 5],
    [6, 2, 3, 7],
    [2, 0, 1, 3],
    [1, 5, 7, 3],
    [0, 2, 6, 4]
]

const faces = [map(x -> Point3f0(inputpoints[x]), p .+ 1) for p in inputfaces]

scene = drawfaces(faces, :black)
display(scene)
sleep(1)

catmullclark(faces, 4, scene)

println("Press Enter to continue", readline())
