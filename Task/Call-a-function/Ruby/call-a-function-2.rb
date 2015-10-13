def foo arg; p arg end          # one argument

foo(1)                          #=> 1
foo "1"                         #=> "1"
foo [0,1,2]                     #=> [0, 1, 2]   (one Array)
