? for period in [3, 5] {
>     def [insert, average] := makeMovingAverage(period)
>     println(`Period $period:`)
>     for value in [1,2,3,4,5,5,4,3,2,1] {
>         insert(value)
>         println(value, "\t", average())
>     }
>     println()
> }

Period 3:
1	1.0
2	1.5
3	2.0
4	3.0
5	4.0
5	4.666666666666667
4	4.666666666666667
3	4.0
2	3.0
1	2.0

Period 5:
1	1.0
2	1.5
3	2.0
4	2.5
5	3.0
5	3.8
4	4.2
3	4.2
2	3.8
1	3.0
