function det2D(p1,p2,p3)
    return p1.x * (p2.y - p3.y)
         + p2.x * (p3.y - p1.y)
         + p3.x * (p1.y - p2.y)
end

function checkTriWinding(p1,p2,p3,allowReversed)
    local detTri = det2D(p1,p2,p3)
    if detTri < 0.0 then
        if allowReversed then
            local t = p3
            p3 = p2
            p2 = t
        else
            error("triangle has wrong winding direction")
        end
    end
    return nil
end

function boundaryCollideChk(p1,p2,p3,eps)
    return det2D(p1,p2,p3) < eps
end

function boundaryDoesntCollideChk(p1,p2,p3,eps)
    return det2D(p1,p2,p3) <= eps
end

function triTri2D(t1,t2,eps,allowReversed,onBoundary)
    eps = eps or 0.0
    allowReversed = allowReversed or false
    onBoundary = onBoundary or true

    -- triangles must be expressed anti-clockwise
    checkTriWinding(t1[1], t1[2], t1[3], allowReversed)
    checkTriWinding(t2[1], t2[2], t2[3], allowReversed)

    local chkEdge
    if onBoundary then
        -- points on the boundary are considered as colliding
        chkEdge = boundaryCollideChk
    else
        -- points on the boundary are not considered as colliding
        chkEdge = boundaryDoesntCollideChk
    end

    -- for edge E of triangle 1
    for i=0,2 do
        local j = (i+1)%3

        -- check all points of triangle 2 lay on the external side of the edge E.
        -- If they do, the triangles do not collide
        if chkEdge(t1[i+1], t1[j+1], t2[1], eps) and
           chkEdge(t1[i+1], t1[j+1], t2[2], eps) and
           chkEdge(t1[i+1], t1[j+1], t2[3], eps) then
            return false
        end
    end

    -- for edge E of triangle 2
    for i=0,2 do
        local j = (i+1)%3

        -- check all points of triangle 1 lay on the external side of the edge E.
        -- If they do, the triangles do not collide
        if chkEdge(t2[i+1], t2[j+1], t1[1], eps) and
           chkEdge(t2[i+1], t2[j+1], t1[2], eps) and
           chkEdge(t2[i+1], t2[j+1], t1[3], eps) then
            return false
        end
    end

    -- the triangles collide
    return true
end

function formatTri(t)
    return "Triangle: ("..t[1].x..", "..t[1].y
                .."), ("..t[2].x..", "..t[2].y
                .."), ("..t[3].x..", "..t[3].y..")"
end

function overlap(t1,t2,eps,allowReversed,onBoundary)
    if triTri2D(t1,t2,eps,allowReversed,onBoundary) then
        return "overlap\n"
    else
        return "do not overlap\n"
    end
end

-- Main
local t1 = {{x=0,y=0},{x=5,y=0},{x=0,y=5}}
local t2 = {{x=0,y=0},{x=5,y=0},{x=0,y=6}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2))

t1 = {{x=0,y=0},{x=0,y=5},{x=5,y=0}}
t2 = {{x=0,y=0},{x=0,y=5},{x=5,y=0}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2,0.0,true))

t1 = {{x=0,y=0},{x=5,y=0},{x=0,y=5}}
t2 = {{x=-10,y=0},{x=-5,y=0},{x=-1,y=6}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2))

t1 = {{x=0,y=0},{x=5,y=0},{x=2.5,y=5}}
t2 = {{x=0,y=4},{x=2.5,y=-1},{x=5,y=4}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2))

t1 = {{x=0,y=0},{x=1,y=1},{x=0,y=2}}
t2 = {{x=2,y=1},{x=3,y=0},{x=3,y=2}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2))

t1 = {{x=0,y=0},{x=1,y=1},{x=0,y=2}}
t2 = {{x=2,y=1},{x=3,y=-2},{x=3,y=4}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2))

-- Barely touching
t1 = {{x=0,y=0},{x=1,y=0},{x=0,y=1}}
t2 = {{x=1,y=0},{x=2,y=0},{x=1,y=1}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2,0.0,false,true))

-- Barely touching
local t1 = {{x=0,y=0},{x=1,y=0},{x=0,y=1}}
local t2 = {{x=1,y=0},{x=2,y=0},{x=1,y=1}}
print(formatTri(t1).." and")
print(formatTri(t2))
print(overlap(t1,t2,0.0,false,false))
