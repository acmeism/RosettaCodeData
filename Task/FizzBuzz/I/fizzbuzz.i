software {
	for i over [1,100]		
		if i mod 15 = 0
			print("FizzBuzz")
		elseif i mod 3 = 0
			print("Fizz")
		elseif i mod 5 = 0
			print("Buzz")
		else
			print(i)
		end
	end
}
