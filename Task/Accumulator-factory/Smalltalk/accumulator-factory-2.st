|factory accu1 accu2|

factory := [:initial |
    [
        |sum|

        sum := initial.
        [:addend | sum := sum + addend].
    ] value.
].

accu1 := factory value:1.
accu1 value:5.
accu2 := factory value:10.
accu2 value:5.
(accu1 value:2.3) printCR.  "-> 8.3 (a float)"
(accu2 value:0) printCR.    "-> 15 (an integer)"
(accu2 value:22 factorial) printCR.    "-> a large integer"
