// find O'Halloran numbers - numbers that cannot be the surface area of
//                           a cuboid with integer dimensions
'use strict'
const maxArea     = 1000
const halfMaxArea = Math.trunc( maxArea / 2 )
let   list        = ""
for( let n = 8; n <= maxArea; n += 2 )
{
    let oHalloran = true
    for( let l = 1; l <= halfMaxArea && oHalloran; l ++ )
    {
        for( let b = l; b <= halfMaxArea; b ++ )
        {
            const lb = l * b
            if( lb >= n || ! oHalloran )break
            for( let h = b; h <= halfMaxArea; h ++ )
            {
                const bh  = b * h, lh = l * h
                const sum = 2 * ( lb + bh + lh )
                oHalloran = sum != n
                if( sum > n || ! oHalloran )break;
            }
        }
    }
    if( oHalloran )
    {
        list = list + " " + n
    }
}
console.log( list )
