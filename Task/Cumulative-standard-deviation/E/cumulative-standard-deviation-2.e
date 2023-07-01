? def [insert, stddev] := makeRunningStdDev()
# value: <insert>, <stddev>

? [stddev()]
# value: [null]

? for value in [2,4,4,4,5,5,7,9] {
>     insert(value)
>     println(stddev())
> }
0.0
1.0
0.9428090415820626
0.8660254037844386
0.9797958971132716
1.0
1.3997084244475297
2.0
