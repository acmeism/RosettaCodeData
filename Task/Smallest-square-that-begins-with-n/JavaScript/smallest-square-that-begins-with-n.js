{  // find the smallest square that begins with n for n in 1..49
   'use strict'
   const smsq = function( n ) {
        let results = [], found = 0, square = 1, delta = 3
        while( found < n ) {
            let k = square
            while( k > 0 ) {
                if( k <= n && results[ k ] == null ) {
                    results[ k ] = square
                    found += 1
                }
                k = Math.floor( k / 10 )
            }
            square = square + delta
            delta  = delta  + 2
        }
        return results
    } // smsq

    const seq = smsq( 49 )
    let out = ""
    for( let i = 1; i < seq.length; i ++ ) {
        out += seq[ i ].toString().padStart( 6 )
        if( i % 10 == 0 ){ out += "\n" }
    }
    console.log( out )
}
