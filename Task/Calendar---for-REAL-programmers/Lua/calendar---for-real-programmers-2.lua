do io.input( arg[ 1 ] ); local s = io.read( "*a" ):lower(); io.close(); assert( load( s ) )() end
