on fizzBuzz(n)
    script o
        property output : {}
    end script

    repeat with i from 1 to n
        if (i mod 3 = 0) then
            if (i mod 15 = 0) then
                set end of o's output to "FizzBuzz"
            else
                set end of o's output to "Fizz"
            end if
        else if (i mod 5 = 0) then
            set end of o's output to "Buzz"
        else
            set end of o's output to i
        end if
    end repeat

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to linefeed
    set output to o's output as text
    set AppleScript's text item delimiters to astid

    return output
end fizzBuzz

fizzBuzz(100)
