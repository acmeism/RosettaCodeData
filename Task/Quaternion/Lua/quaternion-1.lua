Quaternion = {}

function Quaternion.new( a, b, c, d )
    local q = { a = a or 1, b = b or 0, c = c or 0, d = d or 0 }

    local metatab = {}
    setmetatable( q, metatab )
    metatab.__add = Quaternion.add
    metatab.__sub = Quaternion.sub
    metatab.__unm = Quaternion.unm
    metatab.__mul = Quaternion.mul

    return q
end

function Quaternion.add( p, q )
    if type( p ) == "number" then
	return Quaternion.new( p+q.a, q.b, q.c, q.d )
    elseif type( q ) == "number" then
	return Quaternion.new( p.a+q, p.b, p.c, p.d )
    else
	return Quaternion.new( p.a+q.a, p.b+q.b, p.c+q.c, p.d+q.d )
    end
end

function Quaternion.sub( p, q )
    if type( p ) == "number" then
	return Quaternion.new( p-q.a, q.b, q.c, q.d )
    elseif type( q ) == "number" then
	return Quaternion.new( p.a-q, p.b, p.c, p.d )
    else
	return Quaternion.new( p.a-q.a, p.b-q.b, p.c-q.c, p.d-q.d )
    end
end

function Quaternion.unm( p )
    return Quaternion.new( -p.a, -p.b, -p.c, -p.d )
end

function Quaternion.mul( p, q )
    if type( p ) == "number" then
	return Quaternion.new( p*q.a, p*q.b, p*q.c, p*q.d )
    elseif type( q ) == "number" then
	return Quaternion.new( p.a*q, p.b*q, p.c*q, p.d*q )
    else
	return Quaternion.new( p.a*q.a - p.b*q.b - p.c*q.c - p.d*q.d,
                               p.a*q.b + p.b*q.a + p.c*q.d - p.d*q.c,
 			       p.a*q.c - p.b*q.d + p.c*q.a + p.d*q.b,
			       p.a*q.d + p.b*q.c - p.c*q.b + p.d*q.a )
    end
end

function Quaternion.conj( p )
    return Quaternion.new( p.a, -p.b, -p.c, -p.d )
end

function Quaternion.norm( p )
    return math.sqrt( p.a^2 + p.b^2 + p.c^2 + p.d^2 )
end

function Quaternion.print( p )
    print( string.format( "%f + %fi + %fj + %fk\n", p.a, p.b, p.c, p.d ) )
end
