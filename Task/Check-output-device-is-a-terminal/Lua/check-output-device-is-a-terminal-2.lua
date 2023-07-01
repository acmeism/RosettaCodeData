local unistd = require( "posix.unistd" )

local function isTTY ( fd )
    fd = tonumber( fd ) or 1
    local ok, err, errno = unistd.isatty( fd )
    return ok and true or false
end

print( "stdin", isTTY( 0 ) )
print( "stdout", isTTY( 1 ) )
print( "stderr", isTTY( 2 ) )
