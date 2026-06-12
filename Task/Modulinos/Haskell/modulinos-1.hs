$ runhaskell scriptedmain.hs
Main: The meaning of life is 42
$ runhaskell test.hs
Test: The meaning of life is 42
$ ghc -fforce-recomp -o scriptedmain -main-is ScriptedMain scriptedmain.hs
$ ./scriptedmain
Main: The meaning of life is 42
$ ghc -fforce-recomp -o test -main-is Test test.hs scriptedmain.hs
$ ./test
Test: The meaning of life is 42
