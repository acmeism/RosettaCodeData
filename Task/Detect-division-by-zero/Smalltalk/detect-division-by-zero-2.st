testZeroDivide :=
    [:aBlock |
	[
            aBlock value.
            false
        ] on: ZeroDivide do: [true].
    ].

"Testing"
testZeroDivide value: [2/1] "------> false"
testZeroDivide value: [2/0] "------> true"
