#include <condition_variable>
#include <cstdint>
#include <exception>
#include <iostream>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

std::mutex mutex;
std::condition_variable condition_variable;
bool goose_working = true;
bool humpty_working = true;
uint32_t turn = 0;

class out_of_ink_exception : public std::exception { };

class Printer {
public:
	Printer(const std::string& name, const uint32_t& client_ink_level)
		: name(name), client_ink_level(client_ink_level) { }

	bool operator==(const Printer& other) const {
		return name == other.name;
	}

	std::string name;
	uint32_t client_ink_level;
};

Printer reserve("Reserve", 5);
Printer primary("Primary", 5);
Printer printer = primary;

void display(const std::string& text) {
	if ( printer == primary && printer.client_ink_level == 0 ) {
		printer = reserve;
	}

	if ( printer.client_ink_level > 0 ) {
		printer.client_ink_level--;
		std::cout << "(" + printer.name + ") " + text << std::endl;
	} else {
		std::cout << "      Printer out of ink" << std::endl;
		throw out_of_ink_exception();
	}
}

auto messenger =
    [](const std::vector<std::string>& message, const uint32_t& my_turn, const uint32_t& turn_count) {
	std::unique_lock<std::mutex> lock(mutex);
	uint64_t index = 0;
	while ( goose_working || humpty_working ) {
		condition_variable.wait(lock, [&]() { return turn % turn_count == my_turn; });

		if ( index < message.size() ) {
			try {
				display(message[index++]);
			} catch (const out_of_ink_exception& ex) {
				goose_working = false;
				humpty_working = false;
			}
		} else {
			if ( my_turn == 0  ) {
				goose_working = false;
			} else {
				humpty_working = false;
			}
		}

		turn++;
		condition_variable.notify_one();
	}

};

int main() {
	const std::vector<std::string> goose_text = { "Old Mother Goose,",
					  							  "When she wanted to wander,",
					  							  "Would ride through the air,",
												  "On a very fine gander.",
												  "Jack's mother came in,",
												  "And caught the goose soon,",
											      "And mounting its back,",
												  "Flew up to the moon." };

	const std::vector<std::string> humpty_text = { "Humpty Dumpty sat on a wall.",
					     						   "Humpty Dumpty had a great fall.",
												   "All the king's horses and all the king's men,",
												   "Couldn't put Humpty together again." };

	std::thread goose_thread(messenger, goose_text, 0, 2);
	std::thread humpty_thread(messenger, humpty_text, 1, 2);

	goose_thread.join();
	humpty_thread.join();
}
