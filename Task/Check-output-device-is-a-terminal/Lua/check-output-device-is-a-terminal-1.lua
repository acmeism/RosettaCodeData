local function isTTY ( fd )
    fd = tonumber( fd ) or 1
    local ok, exit, signal = os.execute( string.format( "test -t %d", fd ) )
    return (ok and exit == "exit") and signal == 0 or false
end

print( "stdin", isTTY( 0 ) )
print( "stdout", isTTY( 1 ) )
print( "stderr", isTTY( 2 ) )
