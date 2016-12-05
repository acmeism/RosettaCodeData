for i = 1,100
    print ((a) -> a == "" and i or a) table.concat {
        i % 3 == 0 and "Fizz" or ""
        i % 5 == 0 and "Buzz" or ""}
