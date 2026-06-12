using LinearAlgebra # use builtin library for normalize, cross, dot
using JSON3

getangleradians(v1, v2) = acos(dot(v1, v2) / (norm(v1) * norm(v2)))

function rodrotate(pointvector, rotationvector, radians)
    ca, sa = cos(radians), sin(radians)
    t = 1 - ca
    x, y, z = rotationvector
    return [[ca + x * x * t, x * y * t - z * sa, x * z * t + y * sa]';
        [x * y * t + z * sa, ca + y * y * t, y * z * t - x * sa]';
        [z * x * t - y * sa, z * y * t + x * sa, ca + z * z * t]'] * pointvector
end

v1 = [5, -6, 4]
v2 = [8, 5, -30]
a = getangleradians(v1, v2)
cp = cross(v1, v2)
ncp = normalize(cp)
np = rodrotate(v1, ncp, a)
JSON3.write(np)  # "[2.2322210733082284,1.3951381708176411,-8.370829024905854]"
