using Printf
using Plots

function converge(startvalue, decimals = 36, maxiters = 10000)
    current, previous = startvalue, startvalue + 5
    for i in 0:maxiters
        if abs(previous - current) <= big"10.0"^(-decimals)
            return current, i
        end
        previous = current
        current += 3
        current *= big"0.86"
    end
    error("Too many iterations, over $maxiters")
end

print("Enter starting value --> ")
input = something(tryparse(BigFloat, readline()), big"0.0")
print("Enter number of decimal places --> ")
decimals = something(tryparse(Int, readline()), 36)
endvalue, iters = converge(input, decimals)
@printf("%f --> %.*f to %d places after %d repetitions",
   input, decimals, endvalue, decimals, iters)

startvalues = collect(0:0.1:36)
iterationcounts = [last(converge(BigFloat(x))) for x in startvalues]

plot(startvalues, iterationcounts, xlabel = "Starting input",
   ylabel = "Iterations to reach 36 digit precision")
