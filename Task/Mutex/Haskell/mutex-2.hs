   x: = mutex()  # create and return a mutex handle for sharing between threads needing to synchronize with each other

   lock(x)       # lock mutex x

   trylock(x))   # non-blocking lock, succeeds only if there are no other thread already in the critical region

   unlock(x)     # unlock mutex x
