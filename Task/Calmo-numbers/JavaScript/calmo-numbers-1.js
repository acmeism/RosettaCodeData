{  // find some "Calmo" numbers: numbers n such that they have 3k divisors
   // (other than 1 and n) for some k > 0 and the sum of their divisors
   // taken three at a time is a prime

   'use strict'

   const maxNumber = 1000                  // largest number we will consider
   // construct a sieve of (hopefully) enough primes - as we are going to sum
   // the divisors in groups of three, it should be (more than) large enough
   let  isPrime = []
   const maxPrime = maxNumber * 3
   for( let sPos = 1; sPos <= maxPrime; sPos ++ ){ isPrime[ sPos ] = sPos % 2 == 1 }
   isPrime[ 1 ] = false
   isPrime[ 2 ] = true
   const rootMaxPrime = Math.floor( Math.sqrt( maxPrime ) )
   for( let sPos = 3; sPos <= rootMaxPrime; sPos += 2 ) {
      if( isPrime[ sPos ] ){
          for( let p = sPos * sPos; p <= maxPrime; p += sPos ){ isPrime[ p ] = false }
      }
   }

   // construct tables of the divisor counts and divisor sums and check for
   // the numbers as we do it
   // as we are ignoring 1 and n, the initial counts and sums will be 0
   // but we should ignore primes
   let dsum = [], dcount = []
   for( let i = 1; i <= maxNumber; i ++ ){
       dsum[ i ] = dcount[ i ] = ( isPrime[ i ] ? -1 : 0 )
   }
   for( let i = 2; i <= maxNumber; i ++ ){
       for( let j = i + i; j <= maxNumber; j += i ){
           // have another proper divisor
           if( dsum[ j ] >= 0 ){
               // this number is still a candidate
               dsum[   j ] = dsum[   j ] + i
               dcount[ j ] = dcount[ j ] + 1
               if( dcount[ j ] == 3 ){
                   // the divisor count is currently 3
                   // if the divisor sum isn't prime, ignore it in future
                   // if the divisor sum is prime, reset the sum and count
                   dsum[ j ] = dcount[ j ] = ( ! isPrime[ dsum[ j ] ] ? -1 : 0 )
               }
           }
       }
   }
   // show the numbers, they will have 0 in the divisor count
   let calmoNumbers = []
   for( let i = 2; i <= maxNumber; i ++ ){
       if( dcount[ i ] == 0 ){
           calmoNumbers.push( i )
       }
   }
   console.log( calmoNumbers )
}
