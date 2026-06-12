class Main // steady squares
{
    static inline var MAX_NUMBER = 10000;

    static function main()
    {
        var powerOfTen = 10;
        var pad        = '   ';
        var lastDigit  = [ 1, 5, 6 ]; // possible final digits
        var n          = -10;
        for ( n10 in 0...Math.floor( MAX_NUMBER / 10 ) + 1 ) {
            n += 10;
            if( n == powerOfTen ) { // the number of digits just increased
                powerOfTen *= 10;
                pad = pad.substr( 1 );
            }
            for( d in 0...lastDigit.length ){
                var nd = n + lastDigit[ d ];
                var n2 = nd * nd;
                if( n2 % powerOfTen == nd ){ // have a steady square
                    Sys.println( '$pad$nd^2 = $n2' );
                }
            }
        }
    }

}
