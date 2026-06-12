"""  julia example for rosettacode.org/wiki/Riordan_number """

using Formatting

const riordans = zeros(BigInt, 10000)
riordans[begin] = 1

for i in firstindex(riordans)+1:lastindex(riordans)-1
    riordans[i + 1] = (i - 1) * (2 * riordans[i] + 3 * riordans[i - 1]) ÷ (i + 1)
end

for i in 0:31
    print(rpad(format(riordans[begin+i], commas = true), 18), (i + 1) % 4 == 0 ? "\n" : "")
end
println("\nThe 1,000th Riordan has $(length(string(riordans[1000]))) digits.")
println("The 10,000th Riordan has $(length(string(riordans[10_000]))) digits.")
