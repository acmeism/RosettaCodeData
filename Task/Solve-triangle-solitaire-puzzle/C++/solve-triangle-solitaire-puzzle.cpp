#include <bitset>
#include <cstdint>
#include <format>
#include <iostream>
#include <map>
#include <string>
#include <vector>

struct Move {
	uint32_t peg;
	uint32_t over;
	uint32_t land;
};

constexpr uint32_t MAX_PEGS = 16;
std::bitset<MAX_PEGS> board{0xFFFE};

std::map<uint32_t, std::vector<Move>> valid_moves = {
	{ 1, { Move(1, 2, 4), Move(1, 3, 6) } },
	{ 2, { Move(2, 4, 7), Move(2, 5, 9) } },
	{ 3, { Move(3, 5, 8), Move(3, 6, 10) } },
	{ 4, { Move(4, 2, 1), Move(4, 5, 6), Move(4, 8, 13), Move(4, 7, 11) } },
	{ 5, { Move(5, 8, 12), Move(5, 9, 14) } },
	{ 6, { Move(6, 3, 1), Move(6, 5, 4), Move(6, 9, 13), Move(6, 10, 15) } },
	{ 7, { Move(7, 4, 2), Move(7, 8, 9) }	},
	{ 8, { Move(8, 5, 3), Move(8, 9, 10) } },
	{ 9, { Move(9, 5, 2), Move(9, 8, 7) } },
	{ 10, { Move(10, 6, 3), Move(10, 9, 8) } },
	{ 11, { Move(11, 7, 4), Move(11, 12, 13) } },
	{ 12, { Move(12, 8, 5), Move(12, 13, 14) } },
	{ 13, { Move(13, 12, 11), Move(13, 8, 5), Move(13, 9, 6), Move(13, 14, 15) }	},
	{ 14, { Move(14, 13, 12), Move(14, 9, 5) } },
	{ 15, { Move(15, 14, 13), Move(15, 10, 6) }	}
};

std::vector<Move> solution;

bool solved() {
	return board.count() == 1;
}

void draw_board() {
	std::string pegs;
	for ( uint32_t i = 1; i < MAX_PEGS; ++i ) {
		pegs[i] = board[i] ? std::format("{:X}", i)[0] : '-';
	}

    std::cout << std::format("       {}\n", pegs[1]);
    std::cout << std::format("      {} {}\n", pegs[2], pegs[3]);
    std::cout << std::format("     {} {} {}\n", pegs[4], pegs[5], pegs[6]);
    std::cout << std::format("    {} {} {} {}\n", pegs[7], pegs[8], pegs[9], pegs[10]);
    std::cout << std::format("   {} {} {} {} {}\n", pegs[11], pegs[12], pegs[13], pegs[14], pegs[15]);
}

void solve() {
    if ( solved() ) {
    	return;
    }

    for ( uint32_t peg = 1; peg < MAX_PEGS; ++peg ) {
        if ( board[peg] ) {
            for ( const Move& move : valid_moves[peg] ) {
                if ( board[move.over] && ! board[move.land] ) {
                    std::bitset<MAX_PEGS> saved_board = board;
                    board[peg] = false;
                    board[move.over] = false;
                    board[move.land] = true;
                    solution.emplace_back(move);
                    solve();
                    if ( solved() ) {  // Otherwise back-track
                    	return;
                    }

                    board = saved_board;
                    solution.pop_back();
                }
            }
        }
    }
}

int main() {
	const uint32_t empty_peg = 1;
	board[empty_peg] = false;
	solve();

	board = std::bitset<MAX_PEGS>{0xFFFE};
	board[empty_peg] = false;
	draw_board();
	std::cout << std::format("Starting with peg {:X} removed\n\n", empty_peg);
	for ( const Move& move : solution ) {
		board[move.peg]  = false;
		board[move.over] = false;
		board[move.land] = true;
		draw_board();
		std::cout << std::format("Peg {:X} jumped over {:X} to land on {:X}\n\n", move.peg, move.over, move.land);
	}
}
