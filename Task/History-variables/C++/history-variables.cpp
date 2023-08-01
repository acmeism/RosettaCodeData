#include <deque>
#include <iostream>
#include <string>

template <typename T>
class with_history {
public:
	with_history(const T& element) {
		history.push_front(element);
	}

	T get() {
		return history.front();
	}

	void set(const T& element) {
		history.push_front(element);
	}

	std::deque<T> get_history() {
		return std::deque<T>(history);
	}

	T rollback() {
		if ( history.size() > 1 ) {
			history.pop_front();
		}
		return history.front();
	}

private:
	std::deque<T> history;
};

int main() {
	with_history<double> number(1.2345);
	std::cout << "Current value of number: " << number.get() << std::endl;

	number.set(3.4567);
	number.set(5.6789);

	std::cout << "Historical values of number: ";
	for ( const double& value : number.get_history() ) {
		std::cout << value << "  ";
	}
	std::cout << std::endl << std::endl;

	with_history<std::string> word("Goodbye");
	word.set("Farewell");
	word.set("Hello");

	std::cout << word.get() << std::endl;
	word.rollback();
	std::cout << word.get() << std::endl;
	word.rollback();
	std::cout << word.get() << std::endl;
	word.rollback();
	std::cout << word.get() << std::endl;
	word.rollback();
}
