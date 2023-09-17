#include <iostream>
#include <vector>
#include <algorithm>

class war_game {
public:
	war_game() {
		for ( char suit : SUITS ) {
			for ( char pip : PIPS ) {
				deck.emplace_back(card(suit, pip));
			}
		}
		std::random_shuffle(deck.begin(), deck.end());

		handA = { deck.begin(), deck.begin() + 26 };
		handB = { deck.begin() + 26, deck.end() };
	}

	void next_turn() {
		card cardA = handA.front(); handA.erase(handA.begin());
		card cardB = handB.front(); handB.erase(handB.begin());
		tabledCards.emplace_back(cardA);
		tabledCards.emplace_back(cardB);
		int32_t rankA = getRank(cardA.pip);
		int32_t rankB = getRank(cardB.pip);
		std::cout << cardA.pip << cardA.suit << "  " << cardB.pip << cardB.suit << std::endl;

		if ( rankA > rankB ) {
			std::cout << "  Player A takes the cards" << std::endl;
			std::random_shuffle(tabledCards.begin(), tabledCards.end());
			handA.insert(handA.end(), tabledCards.begin(), tabledCards.end());
			tabledCards.clear();
		} else if ( rankA < rankB ) {
			std::cout << "  Player B takes the cards" << std::endl;
			std::random_shuffle(tabledCards.begin(), tabledCards.end());
			handB.insert(handB.end(), tabledCards.begin(), tabledCards.end());;
			tabledCards.clear();
		} else {
			std::cout << "      War!" << std::endl;
			if ( game_over() ) {
				return;
			}

			card cardAA = handA.front(); handA.erase(handA.begin());
			card cardBB = handB.front(); handB.erase(handB.begin());
			tabledCards.emplace_back(cardAA);
			tabledCards.emplace_back(cardBB);
			std::cout << "?   ?   Cards are face down" << std::endl;
			if ( game_over() ) {
				return;
			}

			next_turn();
		}
	}

	bool game_over() const {
		return handA.size() == 0 || handB.size() == 0;
	}

	void declare_winner() const {
		if ( handA.size() == 0 && handB.size() == 0 ) {
			std::cout << "The game ended in a tie" << std::endl;
		} else if ( handA.size() == 0 ) {
			std::cout << "Player B has won the game" << std::endl;
		} else {
			std::cout << "Player A has won the game" << std::endl;
		}
	}
private:
	class card {
	public:
		card(const char suit, const char pip) : suit(suit), pip(pip) {};
		char suit, pip;
	};

	int32_t getRank(const char ch)	const {
	    auto it = find(PIPS.begin(), PIPS.end(), ch);
	    if ( it != PIPS.end() ) {
	        return it - PIPS.begin();
	    }
	    return -1;
	}

	std::vector<card> deck, handA, handB, tabledCards;
	inline static const std::vector<char> PIPS = { '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' };
	inline static const std::vector<char> SUITS = { 'C', 'D', 'H', 'S' };
};

int main() {
	war_game wargame;
    srand((unsigned) time(NULL));
	while ( ! wargame.game_over() ) {
		wargame.next_turn();
	}

	wargame.declare_winner();
}
