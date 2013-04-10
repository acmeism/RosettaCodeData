|factory a|

factory := [:initial |
    [
        |sum|

        sum := initial.
        [:addend | sum := sum + addend].
    ] value.
].

a := factory value:1.
a value:5.
factory value:3.
(a value:2.3) printCR  "-> 8.3 "
