#include <iostream>
#include <ratio>
#include <array>
#include <algorithm>
#include <random>

typedef short int Digit;  // Typedef for the digits data type.

constexpr Digit nDigits{4};      // Amount of digits that are taken into the game.
constexpr Digit maximumDigit{9}; // Maximum digit that may be taken into the game.
constexpr short int gameGoal{24};    // Desired result.

typedef std::array<Digit, nDigits> digitSet; // Typedef for the set of digits in the game.
digitSet d;

void printTrivialOperation(std::string operation) { // Prints a commutative operation taking all the digits.
	bool printOperation(false);
	for(const Digit& number : d) {
		if(printOperation)
			std::cout << operation;
		else
			printOperation = true;
		std::cout << number;
	}
	std::cout << std::endl;
}

void printOperation(std::string prefix, std::string operation1, std::string operation2, std::string operation3, std::string suffix = "") {
	std::cout << prefix << d[0] << operation1 << d[1] << operation2 << d[2] << operation3 << d[3] << suffix << std::endl;
}

int main() {
	std::mt19937_64 randomGenerator;
	std::uniform_int_distribution<Digit> digitDistro{1, maximumDigit};
	// Let us set up a number of trials:
	for(int trial{10}; trial; --trial) {
		for(Digit& digit : d) {
			digit = digitDistro(randomGenerator);
			std::cout << digit << " ";
		}
		std::cout << std::endl;
		std::sort(d.begin(), d.end());
		// We start with the most trivial, commutative operations:
		if(std::accumulate(d.cbegin(), d.cend(), 0) == gameGoal)
			printTrivialOperation(" + ");
		if(std::accumulate(d.cbegin(), d.cend(), 1, std::multiplies<Digit>{}) == gameGoal)
			printTrivialOperation(" * ");
		// Now let's start working on every permutation of the digits.
		do {
			// Operations with 2 symbols + and one symbol -:
			if(d[0] + d[1] + d[2] - d[3] == gameGoal) printOperation("", " + ", " + ", " - "); // If gameGoal is ever changed to a smaller value, consider adding more operations in this category.
			// Operations with 2 symbols + and one symbol *:
			if(d[0] * d[1] + d[2] + d[3] == gameGoal) printOperation("", " * ", " + ", " + ");
			if(d[0] * (d[1] + d[2]) + d[3] == gameGoal) printOperation("", " * ( ", " + ", " ) + ");
			if(d[0] * (d[1] + d[2] + d[3]) == gameGoal) printOperation("", " * ( ", " + ", " + ", " )");
			// Operations with one symbol + and 2 symbols *:
			if((d[0] * d[1] * d[2]) + d[3] == gameGoal) printOperation("( ", " * ", " * ", " ) + ");
			if(d[0] * d[1] * (d[2] + d[3]) == gameGoal) printOperation("( ", " * ", " * ( ", " + ", " )");
			if((d[0] * d[1]) + (d[2] * d[3]) == gameGoal) printOperation("( ", " * ", " ) + ( ", " * ", " )");
			// Operations with one symbol - and 2 symbols *:
			if((d[0] * d[1] * d[2]) - d[3] == gameGoal) printOperation("( ", " * ", " * ", " ) - ");
			if(d[0] * d[1] * (d[2] - d[3]) == gameGoal) printOperation("( ", " * ", " * ( ", " - ", " )");
			if((d[0] * d[1]) - (d[2] * d[3]) == gameGoal) printOperation("( ", " * ", " ) - ( ", " * ", " )");
			// Operations with one symbol +, one symbol *, and one symbol -:
			if(d[0] * d[1] + d[2] - d[3] == gameGoal) printOperation("", " * ", " + ", " - ");
			if(d[0] * (d[1] + d[2]) - d[3] == gameGoal) printOperation("", " * ( ", " + ", " ) - ");
			if(d[0] * (d[1] - d[2]) + d[3] == gameGoal) printOperation("", " * ( ", " - ", " ) + ");
			if(d[0] * (d[1] + d[2] - d[3]) == gameGoal) printOperation("", " * ( ", " + ", " - ", " )");
			if(d[0] * d[1] - (d[2] + d[3]) == gameGoal) printOperation("", " * ", " - ( ", " + ", " )");
			// Operations with one symbol *, one symbol /, one symbol +:
			if(d[0] * d[1] == (gameGoal - d[3]) * d[2]) printOperation("( ", " * ", " / ", " ) + ");
			if(((d[0] * d[1]) + d[2]) == gameGoal * d[3]) printOperation("(( ", " * ", " ) + ", " ) / ");
			if((d[0] + d[1]) * d[2] == gameGoal * d[3]) printOperation("(( ", " + ", " ) * ", " ) / ");
			if(d[0] * d[1] == gameGoal * (d[2] + d[3])) printOperation("( ", " * ", " ) / ( ", " + ", " )");
			// Operations with one symbol *, one symbol /, one symbol -:
			if(d[0] * d[1] == (gameGoal + d[3]) * d[2]) printOperation("( ", " * ", " / ", " ) - ");
			if(((d[0] * d[1]) - d[2]) == gameGoal * d[3]) printOperation("(( ", " * ", " ) - ", " ) / ");
			if((d[0] - d[1]) * d[2] == gameGoal * d[3]) printOperation("(( ", " - ", " ) * ", " ) / ");
			if(d[0] * d[1] == gameGoal * (d[2] - d[3])) printOperation("( ", " * ", " ) / ( ", " - ", " )");
			// Operations with 2 symbols *, one symbol /:
			if(d[0] * d[1] * d[2] == gameGoal * d[3]) printOperation("", " * ", " * ", " / ");
			if(d[0] * d[1] == gameGoal * d[2] * d[3]) printOperation("", " * ", " / ( ", " * ", " )");
			// Operations with 2 symbols /, one symbol -:
			if(d[0] * d[3] == gameGoal * (d[1] * d[3] - d[2])) printOperation("", " / ( ", " - ", " / ", " )");
			// Operations with 2 symbols /, one symbol *:
			if(d[0] * d[1] == gameGoal * d[2] * d[3]) printOperation("( ", " * ", " / ", " ) / ", "");
		} while(std::next_permutation(d.begin(), d.end())); // All operations are repeated for all possible permutations of the numbers.
	}
	return 0;
}
