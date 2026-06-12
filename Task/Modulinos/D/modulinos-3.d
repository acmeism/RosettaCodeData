$ ./scriptedmain.d
Main: The meaning of life is 42
$ ./test.d
Test: The meaning of life is 42
$ dmd scriptedmain.d -version=scriptedmain
$ ./scriptedmain
Main: The meaning of life is 42
$ dmd test.d scriptedmain.d -version=test
$ ./test
Test: The meaning of life is 42
