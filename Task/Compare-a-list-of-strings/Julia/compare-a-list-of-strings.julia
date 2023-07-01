allequal(arr::AbstractArray) = isempty(arr) || all(x -> x == first(arr), arr)

test = [["RC", "RC", "RC"], ["RC", "RC", "Rc"], ["RA", "RB", "RC"],
       ["RC"], String[], ones(Int64, 4), 1:4]

for v in test
    println("\n# Testing $v:")
    println("The elements are $("not " ^ !allequal(v))all equal.")
    println("The elements are $("not " ^ !issorted(v))strictly increasing.")
end
