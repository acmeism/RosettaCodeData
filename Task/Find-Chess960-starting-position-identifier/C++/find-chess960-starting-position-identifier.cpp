#include <algorithm>
#include <cstdint>
#include <stdexcept>
#include <iostream>
#include <string>
#include <map>
#include <set>
#include <vector>

const std::set<std::pair<char, int32_t>> correct_pieces = { std::make_pair('R', 2), std::make_pair('N', 2),
									std::make_pair('B', 2), std::make_pair('Q', 1), std::make_pair('K', 1) };

std::map<std::vector<int32_t>, int32_t> knights_table = {
													{ std::vector<int32_t>{ 0, 1 }, 0 },
													{ std::vector<int32_t>{ 0, 2 }, 1 },
													{ std::vector<int32_t>{ 0, 3 }, 2 },
													{ std::vector<int32_t>{ 0, 4 }, 3 },
													{ std::vector<int32_t>{ 1, 2 }, 4 },
													{ std::vector<int32_t>{ 1, 3 }, 5 },
													{ std::vector<int32_t>{ 1, 4 }, 6 },
													{ std::vector<int32_t>{ 2, 3 }, 7 },
													{ std::vector<int32_t>{ 2, 4 }, 8 },
													{ std::vector<int32_t>{ 3, 4 }, 9 } };

void validate(const std::string& position) {
	if ( position.length() != 8 ) {
		throw std::invalid_argument("Chess position has invalid length" + std::to_string(position.length()));
	}

	std::map<char, int32_t> position_map;
	for ( const char& ch : position ) {
		if ( position_map.find(ch) == position_map.end() ) {
			position_map.emplace(ch, 1);
		} else {
			position_map[ch]++;
		}
	}

	std::set<std::pair<char, int32_t>> pieces;
	std::transform(position_map.begin(), position_map.end(), std::inserter(pieces, pieces.begin()),
	    [](const std::pair<char, int32_t>& entry) { return entry; });

	if ( pieces != correct_pieces ) {
		throw std::invalid_argument("Chess position contains incorrect pieces.");
	}

	const std::vector<uint64_t> bishops = { position.find_first_of('B'), position.find_last_of('B') };
	if ( ( bishops[1] - bishops[0] ) % 2 == 0 ) {
		throw std::invalid_argument("Bishops must be on different coloured squares.");
	}

	std::vector<uint64_t> rook_king =
		{ position.find_first_of('R'), position.find_first_of('K'), position.find_last_of('R') };
	if ( ! ( rook_king[0] < rook_king[1] && rook_king[1] < rook_king[2] ) ) {
		throw std::invalid_argument("The king must be between the two rooks.");
	}
}

int32_t calculate_SPID(std::string& position) {

	const int32_t index_one = position.find_first_of('B');
	const int32_t index_two = position.find_last_of('B');
	const int32_t D = ( index_one % 2 == 0 ) ? index_one / 2 : index_two / 2;
	const int32_t L = ( index_one % 2 == 0 ) ? index_two / 2 : index_one / 2;

	position.erase(remove_if(position.begin(), position.end(),
		[](const char& ch){ return ch == 'B'; }), position.end());
	const uint64_t Q = position.find_first_of('Q');

	position.erase(remove_if(position.begin(), position.end(),
		[](const char& ch){ return ch == 'Q'; }), position.end());
	const int32_t N =
		knights_table[ { (int32_t) position.find_first_of('N'), (int32_t) position.find_last_of('N') } ];

	return 96 * N + 16 * Q + 4 * D + L;
}

int main() {
	std::vector<std::string> positions = { "QNRBBNKR", "RNBQKBNR", "RQNBBKRN", "RNQBBKRN" };

	for ( std::string& position : positions ) {
		validate(position);
		std::cout << "Position " << position << " has Chess960 SP-ID = " << calculate_SPID(position) << std::endl;
	}
}
