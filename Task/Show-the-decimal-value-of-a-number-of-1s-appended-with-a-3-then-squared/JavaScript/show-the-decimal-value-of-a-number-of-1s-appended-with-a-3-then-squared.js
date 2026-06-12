'use strict'
let n = 0
for( let i = 1; i < 8; i ++ )
{
    let n3 = ( n * 10 ) + 3
    console.log( n3 + " " + ( n3 * n3 ) )
    n *= 10
    n += 1
}
