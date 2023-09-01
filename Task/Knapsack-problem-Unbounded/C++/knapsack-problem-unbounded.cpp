#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct Item {
	std::string name;
	int32_t value;
	double weight;
	double volume;
};

const std::vector<Item> items = {
	Item("panacea", 3000, 0.3, 0.025),
	Item("ichor", 1800, 0.2, 0.015),
	Item("gold", 2500, 2.0, 0.002)
};
constexpr double MAX_WEIGHT = 25.0;
constexpr double MAX_VOLUME = 0.25;

std::vector<int32_t> count(items.size(), 0);
std::vector<int32_t> best(items.size(), 0);
int32_t best_value = 0;

void knapsack(const uint64_t& i, const int32_t& value, const double& weight, const double& volume) {
    if ( i == items.size() ) {
        if ( value > best_value ) {
            best_value = value;
            best = count;
        }
        return;
    }

    int32_t measure1 = (int32_t) std::floor( weight / items[i].weight );
    int32_t measure2 = (int32_t) std::floor( volume / items[i].volume );
    int32_t measure  = std::min(measure1, measure2);
    count[i] = measure;

    while ( count[i] >= 0 ) {
        knapsack(
            i + 1,
            value  + count[i] * items[i].value,
            weight - count[i] * items[i].weight,
            volume - count[i] * items[i].volume
        );
        count[i]--;
    }
}

int main() {
	knapsack(0, 0, MAX_WEIGHT, MAX_VOLUME);
	std::cout << "Item Chosen  Number Value  Weight  Volume" << std::endl;
	std::cout << "-----------  ------ -----  ------  ------" << std::endl;
	int32_t item_count = 0;
	int32_t number_sum = 0;
	double weight_sum = 0.0;
	double volume_sum = 0.0;
	
	for ( uint64_t i = 0; i < items.size(); ++i ) {
		if ( best[i] == 0 ) {
			continue;
		}
		
		item_count++;
		std::string name = items[i].name;
		int32_t number = best[i];
		int32_t value = items[i].value * number;
		double weight = items[i].weight * number;
		double volume = items[i].volume * number;
		number_sum += number;
		weight_sum += weight;
		volume_sum += volume;
		
		std::cout << std::setw(11) << name << std::setw(6) << number << std::setw(8) << value << std::fixed
				  << std::setw(8) << std::setprecision(2) << weight
				  << std::setw(8) << std::setprecision(2) << volume << std::endl;
	}
	
	std::cout << "-----------  ------ -----  ------  ------" << std::endl;
	std::cout << std::setw(5) << item_count << " items" << std::setw(6) << number_sum << std::setw(8) << best_value
			  << std::setw(8) << weight_sum << std::setw(8) << volume_sum << std::endl;
}
