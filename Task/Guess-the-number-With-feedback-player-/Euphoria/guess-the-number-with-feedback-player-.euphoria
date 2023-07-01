include get.e
include wildcard.e

sequence Respons
integer min, max, Guess
min = 0
max = 100

printf(1,"Think of a number between %d and %d.\n",{min,max})
puts(1,"On every guess of mine you should state whether my guess was\n")
puts(1,"too high, too low, or equal to your number by typing 'h', 'l', or '='\n")

while 1 do
    if max < min then
        puts(1,"I think something is strange here...\n")
        exit
    end if
    Guess = floor((max-min)/2+min)
    printf(1,"My guess is %d, is this correct? ", Guess)
    Respons = upper(prompt_string(""))
    if Respons[1] = 'H' then
        max = Guess-1
    elsif Respons[1] = 'L' then
        min = Guess+1
    elsif Respons[1] = '=' then
        puts(1,"I did it!\n")
        exit
    else
        puts(1,"I do not understand that...\n")
    end if
end while
