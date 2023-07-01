#include <chrono>
#include <csignal>
#include <ctime>
#include <iostream>
#include <thread>

volatile sig_atomic_t gotint = 0;

void handler(int signum) {
	// Set a flag for handling the signal, as other methods like printf are not safe here
	gotint = 1;
}

int main() {
	using namespace std;

	signal(SIGINT, handler);

	int i = 0;
	clock_t startTime = clock();
	while (true) {
		if (gotint) break;
		std::this_thread::sleep_for(std::chrono::milliseconds(500));
		if (gotint) break;
		cout << ++i << endl;
	}
	clock_t endTime = clock();

	double dt = (endTime - startTime) / (double)CLOCKS_PER_SEC;
	cout << "Program has run for " << dt << " seconds" << endl;

	return 0;
}
