$ gcc -o scriptedmain -lobjc -framework foundation scriptedmain.m
$ gcc -o test -lobjc -framework foundation test.m scriptedmain.m
$ ./scriptedmain
Main: The meaning of life is 42
$ ./test
Test: The meaning of life is 42
