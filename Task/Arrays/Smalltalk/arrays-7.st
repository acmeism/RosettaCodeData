oc := OrderedCollection withAll: #(4 5 6).
oc add:1. oc add:2. oc add:3.
foo := oc removeFirst.
oc addFirst:10.
oc removeLast.
oc at:2 put: 'someString'.
oc add:123 beforeIndex:10.
oc asArray printCR.
oc2 := oc copyFrom:5 to:10
oc indexOf: 'someString'
oc findFirst:[:el  | el isString]
"hundreds of other methods skipped here.."
