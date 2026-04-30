         >>SOURCE FORMAT FREE
identification division.
program-id. fizzbuzz.
data division.
working-storage section.
01  i pic 999.
01  fizz pic 999 value 3.
01  buzz pic 999 value 5.
procedure division.
start-fizzbuzz.
    perform varying i from 1 by 1 until i > 100
        evaluate i also i
        when fizz also buzz
            display 'fizzbuzz'
            add 3 to fizz
            add 5 to buzz
        when fizz also any
            display 'fizz'
            add 3 to fizz
        when buzz also any
            display 'buzz'
            add 5 to buzz
        when other
            display i
        end-evaluate
    end-perform
    stop run
    .
end program fizzbuzz.
