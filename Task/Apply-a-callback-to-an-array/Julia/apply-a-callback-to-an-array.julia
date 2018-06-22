numbers = [1, 3, 5, 7]

@show [n ^ 2 for n in numbers]                  # list comprehension
square(x) = x ^ 2; @show map(square, numbers)   # functional form
@show map(x -> x ^ 2, numbers)                  # functional form with anonymous function
@show [n * n for n in numbers]    				# no need for a function,
@show numbers .* numbers                        # element-wise operation
@show numbers .^ 2                              # includes .+, .-, ./, comparison, and bitwise operations as well
