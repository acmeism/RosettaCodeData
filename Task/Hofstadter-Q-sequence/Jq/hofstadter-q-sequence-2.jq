$ uname -a
Darwin Mac-mini 13.3.0 Darwin Kernel Version 13.3.0: Tue Jun  3 21:27:35 PDT 2014; root:xnu-2422.110.17~1/RELEASE_X86_64 x86_64
$ time jq -r -n -f hofstadter.jq
Q(0) = 1
Q(1) = 1
Q(2) = 1
Q(3) = 2
Q(4) = 3
Q(5) = 3
Q(6) = 4
Q(7) = 5
Q(8) = 5
Q(9) = 6
Q(10) = 6
Q(1000) = 502
flips(100000) = 49798

real	0m0.562s
user	0m0.541s
sys	0m0.011s
