#include <chrono>
#include <cstdint>
#include <iostream>
#include <thread>

class Metronome {
public:
	Metronome(const int32_t& aBeats_per_minute, const int32_t& aMeasure, const int32_t& aDuration_in_minutes)
	: beats_per_minute(aBeats_per_minute), measure(aMeasure), duration_in_minutes(aDuration_in_minutes) {
		counter = 0;
	}

	void start() {
		while ( counter < duration_in_minutes * beats_per_minute ) {
			start_time = std::chrono::system_clock::now();

			std::this_thread::sleep_until(time_to_awake());
			counter++;
			if ( counter % measure != 0 ) {
				std::cout << "Tick " << std::flush;
			} else {
				std::cout << "Tock" << std::endl;
			}
		}
	}

private:
	std::chrono::system_clock::time_point time_to_awake() const {
		return start_time + std::chrono::seconds(1);
	}

	std::chrono::system_clock::time_point start_time;
	int32_t counter;

	const int32_t beats_per_minute, measure, duration_in_minutes;
};

int main() {
	Metronome metronome(60, 4, 1);
	metronome.start();
}
