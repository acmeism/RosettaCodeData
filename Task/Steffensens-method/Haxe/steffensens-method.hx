// Steffensens's method - translated from the ATS sample via Algol 68

class OptionalReal
{
    public var      v:Float;
    public var      hasValue:Bool;
    public function new( value:Float, notNull:Bool )
    {
        v = value;
        hasValue = notNull;
    };
}

class Main {

    // Aitken's extrapolation
    static function aitken( f:Float->Float   // function Float to Float
                          , p0:Float         // initial fixed point estimate
                          ):Float
    {
        var p1   = f( p0 );
        var p2   = f( p1 );
        var p1m0 = p1 - p0;
        return p0 - ( p1m0 * p1m0 ) / ( p2 - ( 2 * p1 ) + p0 );
     };

    // finds fixed point p such that f(p) = p
    static function steffensenAitken( f:Float->Float   // function Float to Float
                                    , pinit:Float      // initial estimate
                                    , tol:Float        // tolerance
                                    , maxiter:Float    // maximum number of iterations
                                    ):OptionalReal     // return a Float, IF tolerance is met
    {
        var p0  = pinit;
        var p   = aitken( f, p0 );                 // first iteration
        var i   = 1;
        while( i < ( maxiter - 1 ) && Math.abs( p - p0 ) > tol ) {
            p0 = p;
            p  = aitken( f, p0 );
            i += 1;
        }
        if( Math.abs( p - p0 ) > tol ) {
            return new OptionalReal( 0, false );
        } else {
            return new OptionalReal( p, true );
        }
    };

    static function deCasteljau( c0:Float      // control point coordinates (one axis)
                               , c1:Float
                               , c2:Float
                               , t :Float      // the indep}ent parameter
                               )   :Float      // value of x(t) or y(t)
    {
        var s   = 1 - t;
        var c01 = ( s * c0 ) + ( t * c1 );
        var c12 = ( s * c1 ) + ( t * c2 );
        return ( s * c01 ) + ( t * c12 );
    };

    static function xConvexLeftParabola( t:Float ):Float { return deCasteljau( 2, -8, 2, t ); }
    static function yConvexLeftParabola( t:Float ):Float { return deCasteljau( 1,  2, 3, t ); }

    static function implicitEquation( x:Float, y:Float ):Float { return ( 5 * x * x ) + y - 5; }

    static function f( t:Float ):Float // find fixed points of this function
    {
        var x = xConvexLeftParabola( t );
        var y = yConvexLeftParabola( t );
        return implicitEquation( x, y ) + t;
    };

    static function main()
    {
        var t0:Float = 0;
        for( i in 1...12 ) {
            Sys.print( 't0 = $t0 : ' );
            var result = steffensenAitken( f, t0, 0.00000001, 1000 );
            if( ! result.hasValue ) {
                Sys.println( 'no answer' );
            } else {
                var x = xConvexLeftParabola( result.v );
                var y = yConvexLeftParabola( result.v );
                if( Math.abs( implicitEquation( x, y ) ) <= 0.000001 ) {
                    Sys.println( 'intersection at ($x, $y)' );
                } else {
                    Sys.println( 'spurious solution' );
                }
            }
            t0 += 0.1;
        }
    }

}
