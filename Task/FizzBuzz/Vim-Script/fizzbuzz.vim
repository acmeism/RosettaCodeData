for i in range(1, 100)
    if i % 15 == 0
        echo "FizzBuzz"
    elseif i % 5 == 0
        echo "Buzz"
    elseif i % 3 == 0
        echo "Fizz"
    else
        echo i
    endif
endfor
