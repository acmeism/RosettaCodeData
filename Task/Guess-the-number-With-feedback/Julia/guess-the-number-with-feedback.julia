function guesswithfeedback(n::Integer)
    number = rand(1:n)
    print("I choose a number between 1 and $n\nYour guess? ")
    while (guess = readline()) != dec(number)
        if all(isdigit, guess)
            print("Too ", parse(Int, guess) < number ? "small" : "big")
        else
            print("Enter an integer please")
        end
        print(", new guess? ")
    end
    println("You guessed right!")
end

guesswithfeedback(10)
