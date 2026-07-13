Rebol [
    title: "Rosetta code: Introspection"
    file:  %Introspection.r3
    url:   https://rosettacode.org/wiki/Introspection
    needs: 3.0.0 ;; Script will exit if interpreter isn't at least this version
]

print ["Using Rebol" system/product "version" system/version "on" system/platform]
print ["Build info:" mold to-block system/build lf]

;; Verify the version of your currently running interpreter and exit if it is too old.
assert [system/version >= 3.1.2]

;; Create a `bloop` variable if it doesn't exists.
unless value? 'bloop [bloop: -1.4]

if all [
    number? :bloop     ;; check whether the variable "bloop" exists
    any-function? :abs ;; and whether the math-function "abs()" is available
][
    print ["abs" bloop "==" abs bloop]  ;; and if yes compute abs(bloop).
]

;; Report the number of integer variables in global scope, and their sum.
sum: 0 foo: dummy: 23
print "^/Lib scope integers:"
foreach [name value] system/contexts/lib [
    if integer? :value [
        print [" " pad name 8 value]
        sum: sum + value
    ]
]
print "^/User scope integers:"
foreach [name value] system/contexts/user [
    if integer? :value [
        print [" " pad name 8 value]
        sum: sum + value
    ]
]
print ["Sum of all integers:" sum]
