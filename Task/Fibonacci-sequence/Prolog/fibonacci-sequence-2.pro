?- time(fib(0,F)).
% 2 inferences, 0.000 CPU in 0.000 seconds (88% CPU, 161943 Lips)
F = 0.

?- time(fib(10,F)).
% 265 inferences, 0.000 CPU in 0.000 seconds (98% CPU, 1458135 Lips)
F = 55.

?- time(fib(20,F)).
% 32,836 inferences, 0.016 CPU in 0.016 seconds (99% CPU, 2086352 Lips)
F = 6765.

?- time(fib(30,F)).
% 4,038,805 inferences, 1.122 CPU in 1.139 seconds (98% CPU, 3599899 Lips)
F = 832040.

?- time(fib(40,F)).
% 496,740,421 inferences, 138.705 CPU in 140.206 seconds (99% CPU, 3581264 Lips)
F = 102334155.
