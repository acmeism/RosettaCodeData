include get.e

constant lower_limit = 0, upper_limit = 100

integer number, guess
number = rand(upper_limit-lower_limit+1)+lower_limit

printf(1,"Guess the number between %d and %d: ", lower_limit & upper_limit)
while 1 do
    guess = floor(prompt_number("", lower_limit & upper_limit))
    if number = guess then
        puts(1,"You guessed correctly!\n")
        exit
    elsif number < guess then
        puts(1,"You guessed too high.\nTry again: ")
    else
        puts(1,"You guessed to low.\nTry again: ")
    end if
end while
