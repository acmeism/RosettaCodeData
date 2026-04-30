Rebol [
	title: "Rosetta code: Bitwise operations"
	file:  %Bitwise_operations.r3
	url:    https://rosettacode.org/wiki/Bitwise_operations
    needs: 3.10.0
]

do-test: function [code][
    res: try code
    case [
        error?   res [res: join "error: " res/id]
        integer? res [res: enbase to-binary res 2]
    ]
    printf [-21 " == "] reduce [form code res]
]
foreach test [
    [10]
    [2]
    [10 AND 2]
    [10 & 2]
    [10 OR 2]
    [10 | 2]
    [10 XOR 2]
    [10 >> 2]
    [10 << 2]
    [-65432]
    [complement -65432]
    [255]
    [shift 255 -2]
    [shift 255 56]
    [shift/logical 255 56]
][  do-test test ]
