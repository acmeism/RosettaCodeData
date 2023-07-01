function aeval( sequence sArr, integer id )
    for i = 1 to length( sArr ) do
        sArr[ i ] = call_func( id, { sArr[ i ] } )
    end for
    return sArr
end function

object biggun
function biggest( object elem )
    if compare(elem, biggun) > 0 then
        biggun = elem
    end if
    return elem
end function

biggun = 0
object a
a = aeval( {1,1234,62,234,12,34,6}, routine_id("biggest") )
printf( 1, "%d\n", biggun )

sequence s
s = {"antelope", "dog", "cat", "cow", "wolf", "wolverine", "aardvark"}
biggun = "ant"
a = aeval( s, routine_id("biggest") )
printf( 1, "%s\n", {biggun} )
