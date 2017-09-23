/* Concurrency in ooRexx. Example of early reply */
object1 = .example~new
object2 = .example~new
say object1~primes(1,11111111111,11111111114)
say object2~primes(2,11111111111,11111111114)
say "Main ended at" time()
exit
::class example
::method primes
use arg which,bot,top
reply "Start primes"which':' time()
Select
  When which=1 Then Call pd1 bot top
  When which=2 Then Call pd2 bot top
  End
