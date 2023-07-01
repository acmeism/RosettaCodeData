-- if you care..
assert(convert(-360,"degrees","degrees") == 0.0)
assert(convert(360,"degrees","degrees") == 0.0)
assert(convert(-400,"gradians","gradians") == 0.0)
assert(convert(400,"gradians","gradians") == 0.0)
assert(convert(-6400,"mils","mils") == 0.0)
assert(convert(6400,"mils","mils") == 0.0)
assert(convert(-2.0*math.pi,"radians","radians") == 0.0)
assert(convert(2.0*math.pi,"radians","radians") == 0.0)

-- if you must..
function d2d(n) return convert(n,"degrees","degrees") end
function d2g(n) return convert(n,"degrees","gradians") end
function d2m(n) return convert(n,"degrees","mils") end
function d2r(n) return convert(n,"degrees","radians") end
function g2d(n) return convert(n,"gradians","degrees") end
function g2g(n) return convert(n,"gradians","gradians") end
function g2m(n) return convert(n,"gradians","mils") end
function g2r(n) return convert(n,"gradians","radians") end
function m2d(n) return convert(n,"mils","degrees") end
function m2g(n) return convert(n,"mils","gradians") end
function m2m(n) return convert(n,"mils","mils")  end
function m2r(n) return convert(n,"mils","radians") end
function r2d(n) return convert(n,"radians","degrees") end
function r2g(n) return convert(n,"radians","gradians") end
function r2m(n) return convert(n,"radians","mils") end
function r2r(n) return convert(n,"radians","radians") end
