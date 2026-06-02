Rebol [
    title: "Rosetta code: Time a function"
    file:  %Time_a_function.r3
    url:   https://rosettacode.org/wiki/Time_a_function
    needs: 3.21.7 ;; for the /unstable sort
]

;; Rebol has a built-in `delta-time` for benchmarking,
;; but `measure-code` is shown here for illustration.
measure-code: function [
    "Execute a block of code and print its elapsed wall-clock time."
    code   [block!] "Code to measure"
    return: [time!] "The elapsed time"
][
    print ["Code to test:" mold/flat code]
    time: stats/timer
    do code
    time: stats/timer - time
    print ["Elapsed time:" time "/" format-time time]
    time
]

measure-code [data: append/dup clear [] [3 1 2 8 5 7 9 4 6] 10000]
measure-code [sort copy data]

;; Alternatively, use the built-in `profile` function.
;; Benchmark stable vs unstable sort on the same data:
profile [[sort copy data][sort/unstable copy data]]
