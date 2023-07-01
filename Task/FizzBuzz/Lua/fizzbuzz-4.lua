local t = {
        [0]  = "FizzBuzz",
        [3]  = "Fizz",
        [5]  = "Buzz",
        [6]  = "Fizz",
        [9]  = "Fizz",
        [10] = "Buzz",
        [12] = "Fizz"
}

for i = 1, 100 do
        print(t[i%15] or i)
end
