-- An alternate version

include std/console.e

sequence howmany = {"No more bottles","%d bottle","","s"}

for beer = 99 to 1 by -1 do
   display(`
   [1] bottles of beer on the wall,
   [1] bottles of beer.
   Take one down, drink it right down,
   [2][3] of beer.
   `,{beer,
      sprintf(howmany[(beer>1)+1],beer-1),
      howmany[(beer>2)+3]
     })
end for
