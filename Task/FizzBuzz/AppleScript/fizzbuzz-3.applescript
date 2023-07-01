on fizzBuzz(n)
    script o
        property output : {}
    end script

    repeat with i from 1 to n
        set end of o's output to i
    end repeat
    repeat with x in {{3, "Fizz"}, {5, "Buzz"}, {15, "FizzBuzz"}}
        set {m, t} to x
        repeat with i from m to n by m
            set item i of o's output to t
        end repeat
    end repeat

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to linefeed
    set output to o's output as text
    set AppleScript's text item delimiters to astid

    return output
end fizzBuzz

fizzBuzz(100)
