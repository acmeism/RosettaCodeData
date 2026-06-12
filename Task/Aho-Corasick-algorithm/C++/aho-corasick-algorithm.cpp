#include <cstdint>
#include <deque>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>

uint32_t max_state_count; // The maximum number of states required to process the 'targets' words
	// 'results' stores the indexes of all the 'target' words in 'targets' that end in the current state.
	// Multiple indexes are stored in a single value by bit-mapping each index, that is, multiplying by a power of two.
std::vector<uint32_t> results;
	// 'failures' stores the index of the failure link state in the trie for each index of a 'target' word in 'targets'
std::vector<uint32_t> failures;
std::vector<std::vector<uint32_t>>trie; // The trie containing the characters of the 'target' words

constexpr uint32_t ALPHABET_SIZE = 26;

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size(); ++i ) {
		std::cout << vec[i];
		if ( i < vec.size() - 1 ) {
			std::cout << ", ";
		}
	}
	std::cout << "]" << std::endl;
}

// Throw an exception if the given 'word' contains a character which is not a lower case alphabetic letter
void validate_lower_case_letters(const std::string& word) {
	for ( const char& ch : word ) {
		if ( ch < 'a' || ch > 'z' ) {
			throw std::invalid_argument("Invalid character in pattern: " + ch);
		}
	}
}

// Return the next state to which the matching machine will transition
uint32_t find_next_state(uint32_t current_state, const char& next_character) {
	const uint32_t ch = next_character - 'a';

	// Follow the links to the first state not undefined
	while ( trie[current_state][ch] == 0 ) {
		current_state = failures[current_state];
	}

	return trie[current_state][ch];
}

uint32_t build_matching_machine(const std::vector<std::string>& targets) {
	 // Initialisation
	failures.assign(max_state_count, 0);
	results.assign(max_state_count, 0);
	trie = { max_state_count, std::vector<uint32_t>(ALPHABET_SIZE, 0) };

	uint32_t next_state_id = 1; // Initially there is only the empty state

	// Build the trie
	for ( uint32_t i = 0; i < targets.size(); ++i ) {
		std::string target = targets[i];
		validate_lower_case_letters(target);
		uint32_t current_state = 0;

		// Process all characters of the current target
		for ( const char& ch : target ) {
			const uint32_t char_code = ch - 'a';

			// Allocate a new state for 'char_code', if one does not already exist
			if ( trie[current_state][char_code] == 0 ) {
				trie[current_state][char_code] = next_state_id++;
			}

			current_state = trie[current_state][char_code];
		}

		// Bit-map the index of the 'target' word in 'targets' to the 'results' list,
		// indicating that it ends in the 'current_state'
		results[current_state] |= ( 1 << i );
	}

	// Determine 'failures' values using a breadth first search
	std::deque<uint32_t> queue;

	// If an alphabetic character has a positive state, its failure value is zero
	for ( uint32_t ch = 0; ch < ALPHABET_SIZE; ++ch ) {
		if ( trie[0][ch] > 0 ) {
			failures[trie[0][ch]] = 0;
			queue.emplace_back(trie[0][ch]);
		}
	}

	while ( ! queue.empty() ) {
		const uint32_t state = queue.front();
		queue.pop_front();

		// Determine the 'failures' value for all alphabetic characters with an undefined state
		for ( uint32_t ch = 0; ch < ALPHABET_SIZE; ++ch ) {
			if ( trie[state][ch] != 0 ) {
				uint32_t failure = failures[state];

				while ( trie[failure][ch] == 0 ) {
					 failure = failures[failure];
				}

				failure = trie[failure][ch];
				failures[trie[state][ch]] = failure;

				// Merge 'results' values
				results[trie[state][ch]] |= results[failure];

				// Insert the next level state into the queue
				queue.emplace_back(trie[state][ch]);
			}
		};
	}
	return next_state_id; // 'next_state_id' is also the total number of states created
}

// Display all occurrences of the target words in the given text
void search_for_targets(const std::string& text, const std::vector<std::string>& targets) {
	validate_lower_case_letters(text);

	// Initialisation
	std::map<std::string, std::vector<uint32_t>> printable_results;
	for ( const std::string& target : targets ) {
		printable_results[target] = std::vector<uint32_t>();
	}

	uint32_t current_state = 0;

	// Process the characters of 'text' through the matching machine
	for ( uint32_t i = 0; i < text.length(); ++i ) {
		current_state = find_next_state(current_state, text[i]);

		// If a match is not found, move to next character of 'text'
		if ( results[current_state] == 0 ) {
			 continue;
		}

		// A match has been found, so store the start index of the target word in the 'printable_results' map
		for ( uint32_t j = 0; j < targets.size(); ++j ) {
			if ( ( results[current_state] & ( 1 << j ) ) > 0 ) {
				printable_results[targets[j]].emplace_back(i + 1 - targets[j].length());
			}
		}
	}

    // Print the results of the search
	for ( std::pair<std::string, std::vector<uint32_t>> pair : printable_results  ) {
		std::cout << "The word \"" << pair.first << "\" appears in \"" << text << "\" starting at indexes ";
		print_vector(pair.second);
	}
}

int main() {
	std::string text = "abaaabaa";
	std::vector<std::string> targets = { "a", "bb", "aa", "abaa", "abaaa" };
	max_state_count = 0;
	for ( const std::string& target : targets ) {
		max_state_count += target.length();
	}

	build_matching_machine(targets);
	search_for_targets(text, targets);
}
