{ // find the Pisano period of some primes and composites

    const maxNumber = 180
    // sieve the primes to maxNumber
    let isPrime = []
    for( let i = 1; i <= maxNumber; i ++ ){ isPrime[ i ] = i % 2 != 0 }
    isPrime[ 1 ] = false
    isPrime[ 2 ] = true
    const rootMaxNumber = Math.floor( Math.sqrt( maxNumber ) )
    for( let s = 3; s <= rootMaxNumber; s += 2 )
    {
        if( isPrime[ s ] )
        {
            for( let p = s * s; p <= maxNumber; p += s ){ isPrime[ p ] = false }
        }
    }

    function pisano( m ) // returns the Pisano period of m
    {
        let p = 0, c = 1
        for( let i = 0; i < ( m * m ); i ++ )
        {
            [ p, c ] = [ c, ( p + c ) % m ]
            if( p == 0 && c == 1 ){ return i + 1 }
        }
        return 1
    }

    // returns the Pisano period of p^k or 0 if p is not prime or k < 1
    function pisanoPrime( p, k )
    {
        return ( ! isPrime[ p ] || k < 1 ) ? 0 : Math.floor( p ** ( k - 1 ) ) * pisano( p )
    }

    function d4( n ) // returns n formatted in 4 characcters
    {
        return n.toString().padStart( 4 )
    }

    console.log( "Pisano period of p^2 where p is a prime < 15:" )
    let list = ""
    for( let p = 1; p < 15; p ++ )
    {
        if( isPrime[ p ] ){ list += " " + p + ":" + pisanoPrime( p, 2 ) }
    }
    console.log( list )
    console.log( "Pisano period of primes up to 180, non-primes shown as \"*\":" )
    list = ""
    for( p = 1; p <= 180; p ++ )
    {
        list += ( ! isPrime[ p ] ? "   *" : d4( pisanoPrime( p, 1 ) ) )
        if( p % 10 == 0 ){ list += "\n" }
    }
    console.log( list )
    console.log( "Pisano period of positive integers up to 180:" )
    list = ""
    for( let n = 1; n <= 180; n ++ )
    {
        list += d4( pisano( n ) )
        if( n % 10 == 0 ){ list += "\n" }
    }
    console.log( list )

}
