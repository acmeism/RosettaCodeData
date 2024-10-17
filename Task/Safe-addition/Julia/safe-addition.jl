julia> using IntervalArithmetic

julia> n = 2.0
2.0

julia> @interval 2n/3 + 1
[2.33333, 2.33334]

julia> showall(ans)
Interval(2.333333333333333, 2.3333333333333335)

julia> a = @interval(0.1, 0.3)
[0.0999999, 0.300001]

julia> b = @interval(0.3, 0.6)
[0.299999, 0.600001]

julia> a + b
[0.399999, 0.900001]
