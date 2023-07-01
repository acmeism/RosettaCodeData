// Function to construct a new integer from the first and last digits of another
function gapfulness_divisor (number) {
	var digit_string = number.toString(10)
	var digit_count = digit_string.length
	var first_digit = digit_string.substring(0, 1)
	var last_digit = digit_string.substring(digit_count - 1)
	return parseInt(first_digit.concat(last_digit), 10)
}

// Divisibility test to determine gapfulness
function is_gapful (number) {
	return number % gapfulness_divisor(number) == 0
}

// Function to search for the least gapful number greater than a given integer
function next_gapful (number) {
	do {
		++number
	} while (!is_gapful(number))
	return number
}

// Constructor for a list of gapful numbers starting from given lower bound
function gapful_numbers (start, amount) {
	var list = [], count = 0, number = start
	if (amount > 0 && is_gapful(start)) {
		list.push(start)
	}
	while (list.length < amount) {
		number = next_gapful(number)
		list.push(number)
	}
	return list
}

// Formatter for a comma-separated list of gapful numbers
function single_line_gapfuls (start, amount) {
	var list = gapful_numbers(start, amount)
	return list.join(", ")
}

// Windows console output wrapper
function print(message) {
	WScript.StdOut.WriteLine(message)
}

// Main algorithm

function print_gapfuls_with_header(start, amount) {
	print("First " + start + " gapful numbers starting at " + amount)
	print(single_line_gapfuls(start, amount))
}

print_gapfuls_with_header(100, 30)
print_gapfuls_with_header(1000000, 15)
print_gapfuls_with_header(1000000000, 10)
