#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <numeric>
#include <string>
#include <unordered_set>
#include <vector>

typedef std::vector<uint32_t> One_line;
typedef std::vector<One_line> Cycles;

class Permutation {
public:
	// Initialise the length of the strings to be permuted.
	Permutation(uint32_t letters_size) : letters_count(letters_size) { }

	// Return the permutation in one line form that transforms the string 'source' into the string 'destination'.
    const One_line create_one_line(const std::string& source, const std::string& destination) {
        One_line result;
        for ( const char& ch : destination ) {
        	result.emplace_back(source.find(ch) + 1);
        }

        while ( result.back() == result.size() ) {
        	result.pop_back();
        }

        return result;
    }

    // Return the cycles of the permutation given in one line form.
	const Cycles one_line_to_cycles(One_line& one_line) {
		Cycles cycles;
		std::unordered_set<uint32_t> used;
		for ( uint32_t number = 1; used.size() < one_line.size(); ++number ) {
			if ( std::find(used.begin(), used.end(), number) == used.end() ) {
				uint32_t index = index_of(one_line, number) + 1;
				if ( index > 0 ) {
					One_line cycle;
					cycle.emplace_back(number);

					while ( number != index ) {
						cycle.emplace_back(index);
						index = index_of(one_line, index) + 1;
					}

					if ( cycle.size() > 1 ) {
						cycles.emplace_back(cycle);
					}
					used.insert(cycle.begin(), cycle.end());
				}
			}
		}

		return cycles;
	}

	// Return the one line notation of the permutation given in cycle form.
	const One_line cycles_to_one_line(Cycles& cycles) {
		One_line one_line(letters_count);
		std::iota(one_line.begin(), one_line.end(), 1);
		for	( uint32_t number = 1; number <= letters_count; ++number ) {
			for ( One_line& cycle : cycles ) {
				const int32_t index = index_of(cycle, number);
				if ( index >= 0 ) {
					one_line[number - 1] = cycle[( cycle.size() + index - 1 ) % cycle.size()];
					break;
				}
			}
		}

		return one_line;
	}

	// Return the inverse of the given permutation in cycle form.
	const Cycles cycles_inverse(const Cycles& cycles) {
		Cycles cycles_inverse = cycles;
		for ( One_line& cycle : cycles_inverse ) {
			cycle.emplace_back(cycle.front());
			cycle.erase(cycle.begin());
			std::reverse(cycle.begin(), cycle.end());
		}

		return cycles_inverse;
	}

	// Return the inverse of the given permutation in one line notation.
	const One_line one_line_inverse(One_line& one_line) {
		One_line one_line_inverse(one_line.size(), 0);
		for ( uint32_t number = 1; number <= one_line.size(); ++number ) {
			one_line_inverse[number - 1] = index_of(one_line, number) + 1;
		}

		return one_line_inverse;
	}

	// Return the cycles obtained by composing cycleOne first followed by cycleTwo.
	const Cycles combined_cycles(Cycles cycles_one, Cycles cycles_two) {
		Cycles combined_cycles;
		std::unordered_set<uint32_t> used;
		for ( uint32_t number = 1; used.size() < letters_count; ++number ) {
			if ( std::find(used.begin(), used.end(), number) == used.end() ) {
				uint32_t combined = next(cycles_two, next(cycles_one, number));
				One_line cycle;
				cycle.emplace_back(number);

				while ( number != combined ) {
					cycle.emplace_back(combined);
					combined = next(cycles_two, next(cycles_one, combined));
				}

				if ( cycle.size() > 1 ) {
					combined_cycles.emplace_back(cycle);
				}
				used.insert(cycle.begin(), cycle.end());
			}
		}

		return combined_cycles;
	}

	// Return the given string permuted by the permutation given in one line form.
	const std::string one_line_permute_string(const std::string text, const One_line one_line) {
		std::string permuted;
		for ( const uint32_t& index : one_line ) {
			permuted.append(1, text[index - 1]);
		}
		permuted.append(text, permuted.size());

		return permuted;
	}

	// Return the given string permuted by the permutation given in cycle form.
	const std::string cycles_permute_string(const std::string& text, Cycles& cycles) {
		std::string permuted = text;
		for ( const One_line& cycle : cycles ) {
			for ( const uint32_t number : cycle ) {
				permuted[next(cycles, number) - 1] = text[number - 1];
			}
		}

		return permuted;
	}

	// Return the signature of the permutation given in one line form.
	const std::string signature(One_line one_line) {
		Cycles cycles = one_line_to_cycles(one_line);
		uint32_t evenCount = 0;
		for ( const One_line& cycle : cycles ) {
			if ( cycle.size() % 2 == 0 ) {
				evenCount++;
			}
		}

		return ( evenCount % 2 == 0 ) ? "+1" : "-1";
	}

	// Return the order of the permutation given in one line form.
	const uint32_t order(One_line one_line) {
		Cycles cycles = one_line_to_cycles(one_line);

		uint32_t lcm = 1;
		for ( const One_line& cycle : cycles ) {
			const uint32_t size = cycle.size();
			lcm *= size / std::gcd(size, lcm);
		}

		return lcm;
	}

private:
	// Return the index of the given digit in the given vector.
	const int32_t index_of(One_line& numbers, const uint32_t& digit) {
	    One_line::iterator iterator = std::find(numbers.begin(), numbers.end(), digit);
	    return ( iterator == numbers.end() ) ? -1 : std::distance(numbers.begin(), iterator);
	}

    // Return the element to which the given number is mapped by the permutation given in cycle form.
	const uint32_t next(Cycles& cycles, const uint32_t& number) {
		for ( One_line& cycle : cycles ) {
			if ( std::find(cycle.begin(), cycle.end(), number) != cycle.end() ) {
				return cycle[( index_of(cycle, number) + 1 ) % cycle.size()];
			}
		}

		return number;
	}

	const uint32_t letters_count;
 };

std::string to_string(const One_line& one_line) {
	std::string result = "(";
	for ( const uint32_t& number : one_line ) {
		result += std::to_string(number) + " ";
	}

	return result.substr(0, result.length() - 1) + ") ";
}

std::string to_string(const Cycles& cycles) {
	std::string result = "";
	for ( const One_line& cycle : cycles ) {
		result +=  to_string(cycle);
	}

	return result;
}

int main() {
	enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY };

	const std::vector<std::string> day_names =
		{ "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY" };

	const std::vector<std::string> letters = { "HANDYCOILSERUPT", "SPOILUNDERYACHT", "DRAINSTYLEPOUCH",
		"DITCHSYRUPALONE", "SOAPYTHIRDUNCLE", "SHINEPARTYCLOUD", "RADIOLUNCHTYPES" };

	auto previous_day = [day_names] (const uint32_t& today) {
		return ( day_names.size() + today - 1 ) % day_names.size();
	};

	Permutation permutation(letters[0].length());

	std::cout << "On Thursdays Alf and Betty should rearrange their letters using these cycles:" << std::endl;
	One_line one_line_wed_thu = permutation.create_one_line(letters[WEDNESDAY], letters[THURSDAY]);
	Cycles cycles_wed_thu = permutation.one_line_to_cycles(one_line_wed_thu);
	std::cout << to_string(cycles_wed_thu) << std::endl;
	std::cout << "So that " << letters[WEDNESDAY] << " becomes " << letters[THURSDAY] << std::endl;

	std::cout << "\n" << "Or they could use the one line notation:" << std::endl;
	std::cout << to_string(one_line_wed_thu) << std::endl;

	std::cout << "\n" << "To revert to the Wednesday arrangement they should use these cycles:" << std::endl;
	Cycles cycles_thu_wed = permutation.cycles_inverse(cycles_wed_thu);
	std::cout << to_string(cycles_thu_wed) << std::endl;

	std::cout << "\n" << "Or with the one line notation:" << std::endl;
	One_line one_line_thu_wed = permutation.one_line_inverse(one_line_wed_thu);
	std::cout << to_string(one_line_thu_wed) << std::endl;
	std::cout << "So that " << letters[THURSDAY] << " becomes "
			  << permutation.one_line_permute_string(letters[THURSDAY], one_line_thu_wed) << std::endl;

	std::cout << "\n" << "Starting with the Sunday arrangement and applying each of the daily" << std::endl;
	std::cout << "arrangements consecutively, the arrangements will be:" << std::endl;
	std::cout << "\n" << std::string(6, ' ') << letters[SUNDAY] << "\n" << std::endl;
	for ( uint32_t today = 0; today < day_names.size(); ++today ) {
		One_line day_one_line = permutation.create_one_line(letters[previous_day(today)], letters[today]);
		std::cout << std::setw(11) << day_names[today] << ": "
				  << permutation.one_line_permute_string(letters[previous_day(today)], day_one_line)
				  << ( ( day_names[today] == "SATURDAY" ) ? "\n" : "" ) << std::endl;
	}

	std::cout << "\n" << "To go from Wednesday to Friday in a single step they should use these cycles:" << std::endl;
	One_line one_line_thu_fri = permutation.create_one_line(letters[THURSDAY], letters[FRIDAY]);
	Cycles cycles_thu_fri = permutation.one_line_to_cycles(one_line_thu_fri);
	Cycles cycles_wed_fri = permutation.combined_cycles(cycles_wed_thu, cycles_thu_fri);
	std::cout << to_string(cycles_wed_fri) << std::endl;
	std::cout << "So that " << letters[WEDNESDAY] << " becomes "
			  << permutation.cycles_permute_string(letters[WEDNESDAY], cycles_wed_fri) << std::endl;

	std::cout << "\n" << "These are the signatures of the permutations:" << "\n" << std::endl;
	for ( uint32_t today = 0; today < day_names.size(); ++today ) {
		One_line one_line = permutation.create_one_line(letters[previous_day(today)], letters[today]);
		std::cout << std::setw(11) << day_names[today] << ": " << permutation.signature(one_line) << std::endl;
	}

	std::cout << "\n" << "These are the orders of the permutations:" << "\n" << std::endl;
	for ( uint32_t today = 0; today < day_names.size(); ++today ) {
		One_line one_line = permutation.create_one_line(letters[previous_day(today)], letters[today]);
		std::cout << std::setw(11) << day_names[today] << ": " << permutation.order(one_line) << std::endl;
	}

	std::cout << "\n" << "Applying the Friday cycle to a string 10 times:" << std::endl;
	std::string previous = "STOREDAILYPUNCH";
	std::cout << "\n" << " 0 " << previous << "\n" << std::endl;
	for ( uint32_t i = 1; i <= 10; ++i ) {
		previous = permutation.cycles_permute_string(previous, cycles_thu_fri);
		std::cout << std::setw(2) << i << " " << previous << ( ( i == 9 ) ? "\n" : "" ) << std::endl;
	}
}
