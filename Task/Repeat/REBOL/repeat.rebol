Rebol [
    title: "Rosetta code: Repeat"
    file:  %Repeat.r3
    url:   https://rosettacode.org/wiki/Repeat
]

my-repeat: function [
    "Calls a function or evaluates a block N times"
    fn [any-function! block!] "Function or block to execute"
    n  [integer!]         "Number of repetitions"
][
    loop n [do fn]
]

fun: does [print now]

my-repeat :fun 2
my-repeat [print "hello"] 3
