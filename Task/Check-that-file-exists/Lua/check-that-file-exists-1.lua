function output( s, b )
    if b then
        print ( s, " does not exist." )
    else
        print ( s, " does exist." )
    end
end

output( "input.txt",  io.open( "input.txt", "r" ) == nil )
output( "/input.txt", io.open( "/input.txt", "r" ) == nil )
output( "docs",  io.open( "docs", "r" ) == nil )
output( "/docs", io.open( "/docs", "r" ) == nil )
