-- Returns the details of the Heronian Triangle with sides a, b, c or nil if it isn't one
local function tryHt( a, b, c )
    local result
    local s = ( a + b + c ) / 2;
    local areaSquared = s * ( s - a ) * ( s - b ) * ( s - c );
    if areaSquared > 0 then
        -- a, b, c does form a triangle
        local area = math.sqrt( areaSquared );
        if math.floor( area ) == area then
            -- the area is integral so the triangle is Heronian
            result = { a = a, b = b, c = c, perimeter = a + b + c, area = area }
        end
    end
    return result
end

-- Returns the GCD of a and b
local function gcd( a, b ) return ( b == 0 and a ) or gcd( b, a % b ) end

-- Prints the details of the Heronian triangle t
local function htPrint( t ) print( string.format( "%4d %4d %4d %4d      %4d", t.a, t.b, t.c, t.area, t.perimeter ) ) end
-- Prints headings for the Heronian Triangle table
local function htTitle() print( "   a    b    c area perimeter" ); print( "---- ---- ---- ---- ---------" ) end

-- Construct ht as a table of the Heronian Triangles with sides up to 200
local ht = {};
for c = 1, 200 do
    for b = 1, c do
        for a = 1, b do
            local t = gcd( gcd( a, b ), c ) == 1 and tryHt( a, b, c );
            if t then
                ht[ #ht + 1 ] = t
            end
        end
    end
end

-- sort the table on ascending area, perimiter and max side length
-- note we constructed the triangles with c as the longest side
table.sort( ht, function( a, b )
                return a.area < b.area or (   a.area == b.area
                                          and (  a.perimeter <  b.perimeter
                                              or (   a.perimiter == b.perimiter
                                                 and a.c         <  b.c
                                                 )
                                              )
                                          )
                end
           );

-- Display the triangles
print( "There are " .. #ht .. " Heronian triangles with sides up to 200" );
htTitle();
for htPos = 1, 10 do htPrint( ht[ htPos ] ) end
print( " ..." );
print( "Heronian triangles with area 210:" );
htTitle();
for htPos = 1, #ht do
    local t = ht[ htPos ];
    if t.area == 210 then htPrint( t ) end
end
