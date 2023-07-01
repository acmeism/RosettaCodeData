function makenested(list)
    nesting = 0
    str = isempty(list) ? "[]" : ""
    for n in list
        if n > nesting
            str *=  "["^(n - nesting)
            nesting = n
        elseif n < nesting
            str *= "]"^(nesting - n) * ", "
            nesting = n
        end
        str *= "$n, "
    end
    str *= "]"^nesting
    return eval(Meta.parse(str))
end

for test in [[], [1, 2, 4], [3, 1, 3, 1], [1, 2, 3, 1], [3, 2, 1, 3], [3, 3, 3, 1, 1, 3, 3, 3]]
    result = "$test  =>  $(makenested(test))"
    println(replace(result, "Any" => ""))
end
