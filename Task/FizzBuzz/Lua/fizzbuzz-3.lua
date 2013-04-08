word = {"Fizz", "Buzz", "FizzBuzz"}

for i = 1, 100 do
        print(word[(i % 3 == 0 and 1 or 0) + (i % 5 == 0 and 2 or 0)] or i)
end
