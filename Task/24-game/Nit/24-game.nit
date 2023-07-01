redef class Char
	fun is_op: Bool do return "-+/*".has(self)
end

# Get `numbers` and `operands` from string `operation` collect with `gets` in `main` function
# Fill `numbers` and `operands` array with previous extraction
fun exportation(operation: String, numbers: Array[Int], operands: Array[Char]) do
	var previous_char: nullable Char = null
	var number: nullable Int = null
	var negative = false

	for i in operation.length.times do
		var current_char = operation[i]
		var current_int = current_char.to_i

		if (previous_char == null or previous_char.is_op) and current_char == '-' then
			negative = true
			continue
		end

		if current_char.is_digit then
			if number == null then
				number = current_int
			else
				number = number * 10 + current_int
			end
		end

		if negative and (current_char.is_op or i == operation.length - 1) then
			number = number - number * 2
			negative = false
		end

		if (current_char.is_op or i == operation.length - 1) and number != null then
			numbers.add(number)
			number = null
		end

		if not negative and current_char.is_op then
			operands.add(current_char)
		end
		previous_char = current_char
	end
	# Update `numbers` and `operands` array in main function with pointer
end

# Create random numbers between 1 to 9
fun random: Array[Int] do
	return [for i in 4.times do 1 + 9.rand]
end

# Make mathematical operation with `numbers` and `operands` and add the operation result into `random_numbers`
fun calculation(random_numbers, numbers: Array[Int], operands: Array[Char]) do
	var number = 0
	var temp_numbers = numbers.clone

	while temp_numbers.length > 1 do
		var operand = operands.shift
		var a = temp_numbers.shift
		var b = temp_numbers.shift

		if operand == '+' then number = a + b
		if operand == '-' then number = a - b
		if operand == '*' then number = a * b
		if operand == '/' then number = a / b

		temp_numbers.unshift(number)
	end
	if number != 0 then random_numbers.add(number)
end

# Check if used `numbers` exist in the `random_numbers` created
fun numbers_exists(random_numbers, numbers: Array[Int]): Bool do
	for number in numbers do
		if not random_numbers.count(number) >= numbers.count(number) then return false
	end
	return true
end

# Remove `numbers` when they are used
fun remove_numbers(random_numbers, numbers: Array[Int]) do
	for number in numbers do random_numbers.remove(number)
end

# Check if the mathematical `operation` is valid
fun check(operation: String): Bool do
	var previous_char: nullable Char = null
	var next_char: nullable Char = null
	var next_1_char: nullable Char = null

	for i in operation.length.times do
		var current_char = operation[i]

		if i + 1 < operation.length then
			next_char = operation[i + 1]
			if i + 2 < operation.length then
				next_1_char = operation[i + 2]
			else
				next_1_char = null
			end
		else
			next_char = null
		end

		if not current_char.is_op and not current_char.is_digit then return false
		if next_char == null and current_char.is_op then return false

		if previous_char == null  then
			if next_char == null or next_1_char == null then return false
			if current_char == '-' and not next_char.is_digit then return false
			if current_char != '-' and not current_char.is_digit then return false
		else
			if next_char != null then
				if previous_char.is_digit and current_char.is_op and
				not (next_char == '-' and next_1_char != null and
				next_1_char.is_digit or next_char.is_digit) then
					return false
				end
			end
		end
		previous_char = current_char
	end
	return true
end

var random_numbers = new Array[Int]
var operation = ""

random_numbers = random
while not random_numbers.has(24) and random_numbers.length > 1 do
	var numbers = new Array[Int]
	var operands = new Array[Char]

	print "numbers: " + random_numbers.join(", ")
	operation = gets
	if check(operation) then
		exportation(operation, numbers, operands)
		if numbers_exists(random_numbers, numbers) then
			calculation(random_numbers, numbers, operands)
			remove_numbers(random_numbers, numbers)
		else
			print "NUMBERS ERROR!"
		end
	else
		print "STRING ERROR!"
	end
end

if random_numbers.has(24) then print "CONGRATULATIONS" else print "YOU LOSE"
