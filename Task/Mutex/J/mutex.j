   name=. 10 T. 0              NB. create an exclusive mutex
   name=. 10 T. 1               NB. create a shared (aka "recursive" or "reentrant") mutex
   failed=. 11 T. mutex         NB. take an exclusive lock on a mutex (waiting forever if necessary)
   failed=. 11 T. mutex;seconds NB. try to take an exclusive lock on a mutex but may time out
                                NB. failed is 0 if lock was taken, 1 if lock was not taken
   13 T. mutex                  NB. release lock on mutex
