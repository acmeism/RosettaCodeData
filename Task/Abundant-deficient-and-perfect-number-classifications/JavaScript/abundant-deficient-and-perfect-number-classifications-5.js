// classify the numbers 1 : 20 000 as abudant, deficient or perfect
"use strict"
let   abundantCount    = 0
let   deficientCount   = 0
let   perfectCount     = 0
const maxNumber        = 20000
// construct a table of the proper divisor sums
let   pds              = []
pds[ 1 ] = 0
for( let i = 2; i <= maxNumber; i ++ ){ pds[ i ] = 1 }
for( let i = 2; i <= maxNumber; i ++ )
{
    for( let j = i + i; j <= maxNumber; j += i ){ pds[ j ] += i }
}
// classify the numbers
for( let n = 1; n <= maxNumber; n ++ )
{
    if(      pds[ n ] <  n )
    {
        deficientCount ++
    }
    else if( pds[ n ] == n )
    {
        perfectCount  ++
    }
    else // pds[ n ] >  n
    {
        abundantCount ++
    }
}
console.log( "abundant  " +  abundantCount.toString() )
console.log( "deficient " + deficientCount.toString() )
console.log( "perfect   " +   perfectCount.toString() )
