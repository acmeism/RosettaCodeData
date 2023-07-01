function make(xval, yval, zval)
    return {x=xval, y=yval, z=zval}
end

function plus(lhs, rhs)
    return make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
end

function minus(lhs, rhs)
    return make(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
end

function times(lhs, scale)
    return make(scale * lhs.x, scale * lhs.y, scale * lhs.z)
end

function dot(lhs, rhs)
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
end

function tostr(val)
    return "(" .. val.x .. ", " .. val.y .. ", " .. val.z .. ")"
end

function intersectPoint(rayVector, rayPoint, planeNormal, planePoint)
    diff = minus(rayPoint, planePoint)
    prod1 = dot(diff, planeNormal)
    prod2 = dot(rayVector, planeNormal)
    prod3 = prod1 / prod2
    return minus(rayPoint, times(rayVector, prod3))
end

rv = make(0.0, -1.0, -1.0)
rp = make(0.0, 0.0, 10.0)
pn = make(0.0, 0.0, 1.0)
pp = make(0.0, 0.0, 5.0)
ip = intersectPoint(rv, rp, pn, pp)
print("The ray intersects the plane at " .. tostr(ip))
