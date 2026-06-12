#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <random>
#include <stdexcept>
#include <string>
#include <vector>

std::vector<uint32_t> price_list;

struct Price_Detail {
	uint32_t min_price;
	uint32_t max_price;
	uint32_t number_prices;
};

uint32_t get_price_range_count(const uint32_t& start_price, const uint32_t& end_price) {
	uint32_t count = 0;
	for ( const uint32_t& price : price_list ) {
		if ( start_price <= price && price <= end_price ) {
			count++;
		}
	}
	return count;
}

uint32_t get_max_price() {
	uint32_t max = 0;
	for ( const uint32_t& price : price_list ) {
		if ( price > max ) {
			max = price;
		}
	}
	return max;
}

Price_Detail get_5000(const uint32_t& min_price, uint32_t max_price, const uint32_t& number_prices) {
	uint32_t count_prices = get_price_range_count(min_price, max_price);
	double delta = ( max_price - min_price ) / 2.0;
	while ( count_prices != number_prices && delta >= 0.5 ) {
		max_price = std::floor( ( count_prices > number_prices ) ? max_price - delta : max_price + delta );
		count_prices = get_price_range_count(min_price, max_price);
		delta /= 2.0;
	}
	return Price_Detail(0, max_price, count_prices);
}

std::vector<Price_Detail> get_all_5000(
		const uint32_t& min_price, const uint32_t& max_price, const uint32_t& number_prices) {
	Price_Detail price_detail = get_5000(min_price, max_price, number_prices);
	uint32_t greatest_price = price_detail.max_price;
	uint32_t count_prices = price_detail.number_prices;
	std::vector<Price_Detail> price_details(1, Price_Detail(min_price, greatest_price, count_prices));
	while ( greatest_price < max_price ) {
		const uint32_t least_price = greatest_price + 1;
		price_detail = get_5000(least_price, max_price, number_prices);
		greatest_price = price_detail.max_price;
		count_prices = price_detail.number_prices;
		if ( count_prices == 0 ) {
			throw std::invalid_argument(
				"Price list from " + std::to_string(least_price) + " has too many with same price.");
		}
		price_details.emplace_back(Price_Detail(least_price, greatest_price, count_prices));
	}
	return price_details;
}

int main() {
	std::random_device random;
	std::mt19937 generator(random());
	std::uniform_int_distribution<int32_t> distribution_large(99'000, 100'999);
	const uint32_t number_prices = distribution_large(generator);
	std::uniform_int_distribution<int32_t> distribution_small(1, 99'999);
	for ( uint32_t i = 0; i < number_prices; ++i ) {
		price_list.emplace_back(distribution_small(generator));
	}
	const uint32_t max_price = get_max_price();

	std::cout << "Using " << number_prices << " random prices from 0 to " << max_price << std::endl;
	std::vector<Price_Detail> price_details = get_all_5000(0, max_price, 5'000);
	std::cout << "Split into " << price_details.size() << " partitions of 5,000 or fewer elements:" << std::endl;
	for ( Price_Detail price_detail : price_details ) {
		const uint32_t min_partition_price = price_detail.min_price;
		const uint32_t max_partition_price = price_detail.max_price;
		const uint32_t number_partition_prices = price_detail.number_prices;
		std::cout << "    From " << std::setw(6) << min_partition_price << " to "
				  << std::setw(6) << max_partition_price  << " with "
				  << std::setw(4) << number_partition_prices << " items" << std::endl;
	}
}
