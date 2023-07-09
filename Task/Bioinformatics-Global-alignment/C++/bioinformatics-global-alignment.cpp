#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <unordered_map>
#include <unordered_set>
#include <string>
#include <vector>

// Print a report of the given string to the standard output device.
void print_report(const std::string& text) {
	std::unordered_map<char, int32_t> bases;
	for ( const char& ch : text ) {
		bases[ch]++;
	}

	const int32_t total = std::accumulate(bases.begin(), bases.end(), 0,
            [&](int32_t previous_sum, std::pair<char, int32_t> entry) {
                return previous_sum + entry.second;
            });

	std::cout << "Nucleotide counts for: " << ( ( text.length() > 50 ) ? "\n" : "" );
	std::cout << text << std::endl;
	std::cout << "Bases: A " << bases['A'] << ", C: " << bases['C'] << ", G: " << bases['G'] << ", T: " << bases['T']
			  << ", total: " << total << "\n" << std::endl;
}

// Return all permutations of the given list of strings.
std::vector<std::vector<std::string>> permutations(std::vector<std::string>& list) {
	int32_t indexes[list.size()] = {};
	std::vector<std::vector<std::string>> result;
	result.push_back(list);
	int32_t i = 0;
	while ( (uint64_t) i < list.size() ) {
		if ( indexes[i] < i ) {
			const int j = ( i % 2 == 0 ) ? 0 : indexes[i];
			std::swap(list[i], list[j]);
			result.push_back(list);
			indexes[i]++;
			i = 0;
		} else {
			indexes[i] = 0;
			i++;
		}
	}
	return result;
}

// Return 'before' concatenated with 'after', removing the longest suffix of 'before' that matches a prefix of 'after'.
std::string concatenate(const std::string& before, const std::string& after) {
	for ( uint64_t i = 0; i < before.length(); ++i ) {
		if ( after.starts_with(before.substr(i, before.length())) ) {
			return before.substr(0, i) + after;
		}
	}
	return before + after;
}

// Remove duplicate strings and strings which are substrings of other strings in the given list.
std::vector<std::string> deduplicate(const std::vector<std::string>& list) {
	std::vector<std::string> singletons(list);
	std::sort(singletons.begin(), singletons.end());
	singletons.erase(std::unique(singletons.begin(), singletons.end()), singletons.end());

	std::vector<std::string> result(singletons);
	std::unordered_set<std::string> marked_for_removal;
	for ( const std::string& test_word : result ) {
		for ( const std::string& word : singletons ) {
			if ( word != test_word && word.find(test_word) != std::string::npos ) {
				marked_for_removal.emplace(test_word);
			}
		}
	}

	result.erase(std::remove_if(result.begin(), result.end(),
		[&](std::string& word) {
	    	return marked_for_removal.count(word) != 0;
		}
	), result.end());

	return result;
}

// Return a set containing all of the shortest common superstrings of the given list of strings.
std::unordered_set<std::string> shortest_common_superstrings(const std::vector<std::string>& list) {
	std::vector<std::string> deduplicated = deduplicate(list);

	std::unordered_set<std::string> shortest;
	shortest.emplace(std::reduce(list.begin(), list.end(), std::string("")));

	uint64_t shortest_length;
	for ( const std::string& word : list ) {
		shortest_length += word.length();
	}

	for ( std::vector<std::string> permutation : permutations(deduplicated) ) {
		std::string candidate;
		for ( const std::string& word : permutation ) {
			candidate = concatenate(candidate, word);
		}

		if ( candidate.length() < shortest_length ) {
			shortest.clear();
			shortest.emplace(candidate);
			shortest_length = candidate.length();
		} else if ( candidate.length() == shortest_length ) {
			shortest.emplace(candidate);
		}
	}
	return shortest;
}

int main() {
	const std::vector<std::vector<std::string>> test_sequences = {
		{ "TA", "AAG", "TA", "GAA", "TA" },
		{ "CATTAGGG", "ATTAG", "GGG", "TA" },
		{ "AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA" },
		{ "ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT",
		  "GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT",
		  "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
		  "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
		  "AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT",
		  "GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC",
		  "CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT",
		  "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
		  "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC",
		  "GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT",
		  "TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
		  "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
		  "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA" } };

	for ( const std::vector<std::string>& test : test_sequences ) {
		for ( const std::string& superstring : shortest_common_superstrings(test) ) {
			print_report(superstring);
		}
	}
}
