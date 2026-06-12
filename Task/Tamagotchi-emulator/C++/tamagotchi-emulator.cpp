#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <random>
#include <sstream>
#include <string>
#include <vector>

std::random_device random;
std::mt19937 generator(random());

class Tamagotchi {
public:
	Tamagotchi(const std::string& name) : name(name) {}

	void feed() {
		food_level++;
	}

	void play() { // May or may not help with boredom
		boredom = std::max(0, boredom - random_in_range(2));
	}

	void talk() {
		const std::string verb = verbs[random_in_range(verbs.size())];
		const std::string noun = nouns[random_in_range(nouns.size())];
		std::cout << "😮 : " << verb << " the " << noun << std::endl;
		boredom = std::max(0, boredom - 1);
	}

	void clean() {
		poop_level = std::max(0, poop_level - 1);
	}

	void wait() {
		age++;
		boredom += random_in_range(2);
		food_level = std::max(0, food_level - 2);
		poop_level += random_in_range(2);
	}

	bool is_alive() const {
		return sickness() <= 10;
	}

	void health() const {
		const uint32_t sickness_level = sickness();
		std::string icon = "";
		if ( sickness_level <= 2 ) {
			icon = sick_icons_1[random_in_range(sick_icons_1.size())];
		} else if ( sickness_level <= 4 ) {
			icon = sick_icons_2[random_in_range(sick_icons_2.size())];
		} else if ( sickness_level <= 6 ) {
			icon = sick_icons_3[random_in_range(sick_icons_3.size())];
		} else if ( sickness_level <= 10 ) {
			icon = sick_icons_4[random_in_range(sick_icons_4.size())];
		} else {
			icon = sick_icons_5[random_in_range(sick_icons_5.size())];
		}

		std::cout << name << " ( 🎂 " << age << " ) " << icon + " " << sickness_level << status()
				  << std::endl << std::endl;
	}

	void instructions() const {
		std::cout << "When the '?' prompt appears, enter an action," << std::endl;
		std::cout << "optionally followed by the number of repetitions from 1 to 9." << std::endl;
		std::cout << "If no repetitions are specified, 1 repetition will be assumed." << std::endl;
		std::cout << "The available options are: 'feed', 'play', 'talk', 'clean' or 'wait'." << std::endl << std::endl;
	}

private:
	int32_t sickness() const { // Maximum life expectancy is 42 years
		return poop_level + boredom + std::max(0, age - 32) + std::abs(food_level - 2);
	}

	std::string status() const { // If alive, get the boredom, food and poop icons, else R.I.P.
		if ( is_alive() ) {
			std::string boredom_string = "";
			for ( int32_t i = 0; i < boredom; ++i ) {
				boredom_string += boredom_icons[random_in_range(boredom_icons.size())];
			}
			std::string food_string = "";
			for ( int32_t i = 0; i < food_level; ++i ) {
				food_string += food_icons[random_in_range(food_icons.size())];
			}
			std::string poop_string = "";
			for ( int32_t i = 0; i < poop_level; ++i ) {
				poop_string += poop_icons[random_in_range(poop_icons.size())];
			}

			return " { " + boredom_string + " }, { " + food_string + " }, { " + poop_string + " }";
		}

		return " R.I.P";
	}

	int32_t random_in_range(const uint32_t& limit) const {
		std::uniform_int_distribution<int32_t> distribution(0, limit - 1);
		return distribution(generator);
	}

	int32_t age = 0;
	int32_t boredom = 0;
	int32_t food_level = 2;
	int32_t poop_level = 0;
	const std::string name;

	const std::vector<std::string> verbs = {
		"Ask", "Ban", "Bash", "Bite", "Break", "Build",
		"Cut", "Dig", "Drag", "Drop", "Drink", "Enjoy",
		"Eat", "End", "Feed", "Fill", "Force", "Grasp",
		"Gas", "Get", "Grab", "Grip", "Hoist", "House",
		"Ice", "Ink", "Join", "Kick", "Leave", "Marry",
		"Mix", "Nab", "Nail", "Open", "Press", "Quash",
		"Rub", "Run", "Save", "Snap", "Taste", "Touch",
		"Use", "Vet", "View", "Wash", "Xerox", "Yield"
	};

	const std::vector<std::string> nouns = {
		"arms", "bugs", "boots", "bowls", "cabins", "cigars",
		"dogs", "eggs", "fakes", "flags", "greens", "guests",
		"hens", "hogs", "items", "jowls", "jewels", "juices",
		"kits", "logs", "lamps", "lions", "levers", "lemons",
		"maps", "mugs", "names", "nests", "nights", "nurses",
		"orbs", "owls", "pages", "posts", "quests", "quotas",
		"rats", "ribs", "roots", "rules", "salads", "sauces",
		"toys", "urns", "vines", "words", "waters", "zebras"
	};

	const std::vector<std::string> boredom_icons = { "💤", "💭", "❓" };
	const std::vector<std::string> food_icons = { "🍼", "🍔", "🍟", "🍰", "🍜" };
	const std::vector<std::string> poop_icons = { "💩" };
	const std::vector<std::string> sick_icons_1 = { "😄", "😃", "😀", "😊", "😎", "👍" }; // well
	const std::vector<std::string> sick_icons_2 = { "😪", "😥", "😰", "😓" }; // ill
	const std::vector<std::string> sick_icons_3 = { "😩", "😫" }; // very ill
	const std::vector<std::string> sick_icons_4 = { "😡", "😱" }; // seriously bad
	const std::vector<std::string> sick_icons_5 = { "❌", "💀", "👽", "😇" }; // deceased
};

int main() {
	std::cout << "         TAMAGOTCHI EMULATOR" << std::endl;
	std::cout << "         ===================" << std::endl << std::endl;

	std::string name;
	std::cout << "Enter the name of your tamagotchi: ";
	std::cin >> name;
	std::cin.ignore(); // Clear the cin buffer

	Tamagotchi tamagotchi(name);
	std::cout << "Name   age  health {boredom} {food_level} {poop_level}" << std::endl;
	tamagotchi.health();
	tamagotchi.instructions();

	const std::vector<std::string> commands = { "feed", "play", "talk", "clean", "wait" };

	uint32_t count = 0;
	std::string line;
	std::string input;
	while ( tamagotchi.is_alive() ) {
		std::cout << "? ";
		std::getline(std::cin, input);

		std::vector<std::string> items{};
		std::istringstream stream(input);
		while ( std::getline(stream, line, ' ') ) {
			items.emplace_back(line);
		}

		if ( items.size() > 2 ) {
			continue;
		}

		std::string action = items[0];
		if ( std::find(commands.begin(), commands.end(), action) == commands.end() ) {
			continue;
		}

		const uint32_t repetitions = ( items.size() == 2 ) ? std::stoi(items[1]) : 1;

		for ( uint32_t i = 0; i < repetitions; ++i ) {
			if ( action == "feed" ) {
				tamagotchi.feed();
			} else if ( action == "play" ) {
				tamagotchi.play();
			} else if ( action == "talk" ) {
				tamagotchi.talk();
			} else if ( action == "clean" ) {
				tamagotchi.clean();
			} else if ( action == "wait" ) {
				tamagotchi.wait();
			}
			
			if ( action != "wait" ) { // Execute a wait on every third non-wait action
				count++;
				if ( count == 3 ) {
					tamagotchi.wait();
					count = 0;
				}
			}
		}

		tamagotchi.health();
	}
}
