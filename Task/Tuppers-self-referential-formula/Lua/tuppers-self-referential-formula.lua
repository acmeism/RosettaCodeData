do -- plot Tupper's self-referential formula
   --[[    need to find x, y such that:
             1/2 < floor( mod( (y/17)*2^ - ( 17x - mod(y,17) ), 2 ) )
           where x in 0..106, y in k..k+16
   --]]
   local bint = require 'lua-bint-master\\bint'(2048)    -- need around 600 digits

   local k = bint.fromstring( "960939379918958884971672962127852754715004339660129306651505" ..
                              "519271702802395266424689642842174350718121267153782770623355" ..
                              "993237280874144307891325963941337723487857735749823926629715" ..
                              "517173716995165232890538221612403238855866184013235585136048" ..
                              "828693337902491454229288667081096184496091705183454067827731" ..
                              "551705405381627380967602565625016981482083418783163849115590" ..
                              "225610003652351370343874461848378737238198224849863465033159" ..
                              "410054974700593138339226497249461751545728366702369745461014" ..
                              "655997933798537483143786841806593422227898388722980000748404" ..
                              "719" )

    local b2     = bint.frominteger(  2 )
    local b17    = bint.frominteger( 17 )
    local kMod17 = bint.tointeger( k % b17 )
    for yDelta = 0, 16 do
        for x = 106, 0, -1 do
            local powerOf2  = - ( 17 * x ) - ( kMod17 + yDelta ) % 17
            -- if powerOf2 = 0, then ( v * 2 ^ powerOf2 ) mod 2 = v mod 2
            -- if powerOf2 > 0, then ( v * 2 ^ powerOf2 ) mod 2 = 0
            if powerOf2 > 0 then
                io.write( " " )
            else
                local v = ( k + bint.frominteger( yDelta ) ) // b17
                if  powerOf2 < 0 then
                    v = v // bint.ipow( b2, bint.frominteger( - powerOf2 ) )
                end
                v = v % 2
                io.write( ( bint.eq( v, 0 ) and " " ) or "#" )
            end
        end
        io.write( "\n" )
    end
end
