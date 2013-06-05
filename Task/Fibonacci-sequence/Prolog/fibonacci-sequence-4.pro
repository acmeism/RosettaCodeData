?- time(fib(0,F)).
% 2 inferences, 0.000 CPU in 0.000 seconds (90% CPU, 160591 Lips)
F = 0.

?- time(fib(10,F)).
% 37 inferences, 0.000 CPU in 0.000 seconds (96% CPU, 552610 Lips)
F = 55.

?- time(fib(20,F)).
% 41 inferences, 0.000 CPU in 0.000 seconds (96% CPU, 541233 Lips)
F = 6765.

?- time(fib(30,F)).
% 41 inferences, 0.000 CPU in 0.000 seconds (95% CPU, 722722 Lips)
F = 832040.

?- time(fib(40,F)).
% 41 inferences, 0.000 CPU in 0.000 seconds (96% CPU, 543572 Lips)
F = 102334155.
