local dic = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
function encode( t, f )
    local b1, b2, b3, b4
    b1 = 1 + ( ( t & 0xfc0000 ) >> 18 )
    b2 = 1 + ( ( t & 0x03f000 ) >> 12 )
    b3 = 1 + ( ( t & 0x000fc0 ) >>  6 )
    b4 = 1 + ( t & 0x00003f )
    io.write( dic:sub( b1, b1 ), dic:sub( b2, b2 ) )
    if f > 1 then io.write( dic:sub( b3, b3 ) ) else io.write( "=" ) end
    if f > 2 then io.write( dic:sub( b4, b4 ) ) else io.write( "=" ) end
end

local i = assert( io.open( "favicon.ico", "rb" ) )
local iconData = i:read( "*all" )
local dataLen, s, t = #iconData, 1
while( dataLen > 2 ) do
    t =     ( iconData:sub( s, s ):byte() << 16 ); s = s + 1
    t = t + ( iconData:sub( s, s ):byte() <<  8 ); s = s + 1
    t = t + ( iconData:sub( s, s ):byte()       ); s = s + 1
    dataLen = dataLen - 3
    encode( t, 3 )
end
if dataLen == 2 then
    t =     ( iconData:sub( s, s ):byte() << 16 ); s = s + 1;
    t = t + ( iconData:sub( s, s ):byte() <<  8 ); s = s + 1;
    encode( t, 2 )
elseif dataLen == 1 then
    t =     ( iconData:sub( s, s ):byte() << 16 ); s = s + 1;
    encode( t, 1 )
end
print()
