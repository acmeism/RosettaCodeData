{   // calculate and show some primorial numbers
    'use strict'

    let   primorial = 1n
    let   prime     = 1n
    let   pn        = []
    const maxNumber = 2000000
    let   isPrime   = []
    for( let i = 1; i <= maxNumber; i ++ ){ isPrime[ i ] = i % 2 != 0 }
    isPrime[ 1 ] = false
    isPrime[ 2 ] = true
    const rootMaxNumber = Math.floor( Math.sqrt( maxNumber ) )
    for( let s = 3; s <= rootMaxNumber; s += 2 ){
        if( isPrime[ s ] ){
            for( let p = s * s; p <= maxNumber; p += s ){ isPrime[ p ] = false }
        }
    }

    const primeMax = 100000
    pn[ 0 ] = 1
    let nextToShow = 10
    for( let i = 1; i <= primeMax; i ++ ){
        // find the next prime
        prime += 1n
        while( ! isPrime[ prime ] ){ prime += 1n }
        primorial *= prime
        if( i < 10 ){
            pn[ i ] = primorial
        }
        else if( i == nextToShow ){
            if( nextToShow < 10000 ){
                nextToShow *= 10
            }
            else{
                nextToShow += 10000
            }
            if( i == 10 ){ console.log( "primorials 0-9: ", pn.toString() ) }
            // show the number of digits in the primorial
            let p = primorial
            let length = 0
            while( p > 0 ){
                length += 1
                p /= 10n
            }
            console.log( "length of primorial " + i + " is "+  length )
        }
    }
}
