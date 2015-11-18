print("Enter an upper bound: ")
lower = 0
input = readline()
upper = parse(Int, input)

if upper < 1
    throw(DomainError)
end

attempts = 1
print("Think of a number, ", lower, "--", upper, ", then press ENTER.")
readline()
const maxattempts = round(Int, ceil(-log(1 / (upper - lower)) / log(2)))
println("I will need at most ", maxattempts, " attempts ",
    "(⌈-log(1 / (", upper, " - ", lower, ")) / log(2)⌉ = ",
    maxattempts, ").\n")
previous = -1
guess = -1

while true
    previous = guess
    guess = lower + round(Int, (upper - lower) / 2, RoundNearestTiesUp)

    if guess == previous || attempts > maxattempts
        println("\nThis is impossible; did you forget your number?")
        exit()
    end

    print("I guess ", guess, ".\n[l]ower, [h]igher, or [c]orrect? ")
    input = chomp(readline())

    while input ∉ ["c", "l", "h"]
        print("Please enter one of \"c\", \"l\", or \"h\". ")
        input = chomp(readline())
    end

    if input == "l"
        upper = guess
    elseif input == "h"
        lower = guess
    else
        break
    end

    attempts += 1
end

println("\nI win after ", attempts, attempts == 1 ? " attempt." : " attempts.")
