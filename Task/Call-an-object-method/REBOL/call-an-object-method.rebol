Rebol [
    title: "Rosetta code: Call an object method"
    file:  %Call_an_object_method.r3
    url:   https://rosettacode.org/wiki/Call_an_object_method
]

;; object prototype
my-proto!: object [
    val1: val2: 0
    set: func [arg1 arg2] [val1: arg1 val2: arg2]
    sum: does [val1 + val2]
]

;; create an instance with initial values
my-obj1: make my-proto! [val1: 2 val2: 3]
print ["Sum of values in the 1st object:" my-obj1/sum]

;; create an instance and set values via the set function
my-obj2: make my-proto! []
my-obj2/set 1 1
print ["Sum of values in the 2nd object:" my-obj2/sum]

;; confirm the 1st object is unchanged
print ["Sum of values in the 1st object:" my-obj1/sum]
