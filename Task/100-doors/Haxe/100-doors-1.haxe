class Main
{
    static public function main()
    {
        findOpenDoors( 100 );
    }

    static function findOpenDoors( n : Int )
    {
        var door = [];
        for( i in 0...n + 1 ){ door[ i ] = false; }
        for( i in 1...n + 1 ){
            var j = i;
            while( j <= n ){
                door[ j ] = ! door[ j ];
                j += i;
            }
        }
        for( i in 1...n + 1 ){
            if( door[ i ] ){ Sys.print( ' $i' ); }
        }
    }
}
