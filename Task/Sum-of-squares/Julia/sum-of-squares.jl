@show sum([1,2,3,4,5].^2)
@show sum([x^2 for x in [1,2,3,4,5]])
@show mapreduce(x->x^2, +, collect(1:5))
@show sum([x^2 for x in []], init=0)
