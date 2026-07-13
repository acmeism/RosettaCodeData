Rebol [
    title: "Rosetta code: Test a function"
    file:  %Test_a_function.r3
    url:   https://rosettacode.org/wiki/Test_a_function
]

;; This is just an example how to do tests.
;; For Rebol unit tests see: https://github.com/Oldes/Rebol3/tree/master/src/tests

palindrome?: func [s [string!]] [s = reverse copy s]

do-tests: function [
    tests [block!]
    /verbose
][
    print ""
    fails: error: count: 0
    foreach test tests [
        either block? test [
            ++ count
            set/any [res:] try test
            type: case [
                error? :res [++ error #"💥"]
                   did :res [         #"✅"]
                      'else [++ fails #"❌"]
            ]
            if any [verbose type != #"✅"][
                print ["  " type mold test]
            ]
        ][  ;; Print title
            if verbose [print as-yellow test]
        ]
    ]
    print-hline/width 60
    either zero? fails + error [
        print ["   ✅ All" as-green count "tests passed."]
        return true
    ][
        print [
            "   ❌"  as-red fails + error "test(s) failed." as-red error "with error!"]
    ]
]

print "^/Run a verbose test with some errors:"

do-tests/verbose [
    "Palindrom tests:"
    [    palindrome? "aba"]
    [not palindrome? "ab" ]
    [    palindrome? "ab" ]
    [error? try [palindrome? 1]]
    "These tests are invalid:"
    [    palindrome? 1234 ]
    [ 1 / 0 ]
]
print "^/Run a test with no errors:"
do-tests [
    "All tests ok:"
    [    palindrome? "aba"]
    [not palindrome? "ab"]
]
