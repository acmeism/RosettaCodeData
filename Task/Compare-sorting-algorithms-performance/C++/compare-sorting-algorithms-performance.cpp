#include <algorithm>
#include <chrono>
#include <cstdint>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <random>
#include <string>
#include <vector>

std::random_device random_device;
std::mt19937 generator(random_device());

int32_t measure_execution_time(const std::function<void(std::vector<int32_t>)>& sort, const std::vector<int32_t>& sequence) {
	const auto start_time = std::chrono::high_resolution_clock::now();
	sort(sequence);
	const auto stop_time = std::chrono::high_resolution_clock::now();
	return std::chrono::duration_cast<std::chrono::microseconds>(stop_time - start_time).count();
}

std::vector<int32_t> ones(const int32_t& n) {
	std::vector<int32_t> result(n, 1);
	return result;
}

std::vector<int32_t> ascending(const int32_t& n) {
	std::vector<int32_t> result(n);
	std::iota(result.begin(), result.end(), 1);
	return result;
}

std::vector<int32_t> random(const int32_t& n) {
	std::vector<int32_t> result(n);
	std::uniform_int_distribution<int32_t> distribution(1, 10 * n);
	for ( int32_t i = 0; i < n; ++i ) {
		result[i] = distribution(generator);
	}
	return result;
}

std::function<void(const std::vector<int32_t>&)> bubble_sort = [](std::vector<int32_t> vec) {
	int32_t n = vec.size();
	while ( n != 0 ) {
		int32_t n2 = 0;
		for ( int32_t i = 1; i < n; ++i ) {
			if ( vec[i - 1] > vec[i] ) {
				const int32_t temp = vec[i];
				vec[i] = vec[i - 1];
				vec[i - 1] = temp;
				n2 = i;
			}
		}
		n = n2;
	}
};

std::function<void(const std::vector<int32_t>&)> insertion_sort = [](std::vector<int32_t> vec) {
	for ( uint32_t index = 1; index < vec.size(); ++index ) {
		const int32_t value = vec[index];
		int32_t subIndex = index - 1;
		while ( subIndex >= 0 && vec[subIndex] > value ) {
			vec[subIndex + 1] = vec[subIndex];
			subIndex -= 1;
		}
		vec[subIndex + 1] = value;
	}
};

void quick_sort_recursive(std::vector<int32_t>& vec, const int32_t& first, const int32_t& last) {
	if ( last - first < 1 ) {
		return;
	}
	const int32_t pivot = vec[first + ( last - first ) / 2];
	int32_t left = first;
	int32_t right = last;
	while ( left <= right ) {
		while ( vec[left] < pivot ) {
			left += 1;
		}
		while ( vec[right] > pivot ) {
			right -= 1;
		}
		if ( left <= right ) {
			const int32_t temp = vec[left];
			vec[left] = vec[right];
			vec[right] = temp;
			left += 1;
			right -= 1;
		}
	}
	if ( first < right ) {
		quick_sort_recursive(vec, first, right);
	}
	if ( left < last ) {
		quick_sort_recursive(vec, left, last);
	}
}

std::function<void(const std::vector<int32_t>&)> quick_sort = [](std::vector<int32_t> vec) {
	quick_sort_recursive(vec, 0, vec.size() - 1);
};

void counting_sort(const std::vector<int32_t>& vec, const int32_t& exponent) {
	const int32_t vec_size = vec.size();
	std::vector<int32_t> output(vec_size, 0);
	std::vector<int32_t> count(10, 0);
	for ( int32_t i = 0; i < vec_size; ++i ) {
		const int32_t t = ( vec[i] / exponent ) % 10;
		count[t] += 1;
	}
	for ( int32_t i = 1; i <= 9; ++i ) {
		count[i] += count[i - 1];
	}
	for ( int32_t i = vec_size - 1; i >= 0; --i ) {
		const int32_t t = ( vec[i] / exponent ) % 10;
		output[count[t] - 1] = vec[i];
		count[t] -= 1;
	}
}

std::function<void(const std::vector<int32_t>&)> radix_sort = [](std::vector<int32_t> vec) {
	const int32_t min = *min_element(vec.begin(), vec.end());
	if ( min < 0 ) { // If there are any negative numbers, make all the numbers positive
		std::for_each(vec.begin(), vec.end(), [min](int32_t& n) { n -= min; });
	}
	const int32_t max = *std::max_element(vec.begin(), vec.end());
	int32_t exponent = 1;
	while ( max / exponent > 0 ) {
		counting_sort(vec, exponent);
		exponent *= 10;
	}
	if ( min < 0 ) { // If there were any negative numbers, return the array to its original values
		std::for_each(vec.begin(), vec.end(), [min](int32_t& n) { n += min; });
	}
};

std::function<void(const std::vector<int32_t>&)> shell_sort = [](std::vector<int32_t> vec) {
	for ( int32_t gap : { 701, 301, 132, 57, 23, 10, 4, 1 } ) { // Marcin Ciura's gap sequence
		for ( uint32_t i = gap; i < vec.size(); ++i ) {
			const int32_t temp = vec[i];
			int32_t j = i;
			while ( j >= gap && vec[j - gap] > temp ) {
				vec[j] = vec[j - gap];
				j -= gap;
			}
			vec[j] = temp;
		}
	}
};

int main() {
	const uint32_t repetitions = 10;
	std::vector<uint32_t> lengths = { 1, 10, 100, 1'000, 10'000, 100'000 };
	std::vector<std::function<void(const std::vector<int32_t>&)>> sorts =
		{ bubble_sort, insertion_sort, quick_sort, radix_sort, shell_sort };
	std::vector<std::string> sort_titles = { "Bubble", "Insert", "Quick ", "Radix ", "Shell " };
	std::vector<std::string> sequence_titles = { "All Ones", "Ascending", "Random" };

	std::vector<std::vector<std::vector<int64_t>>> totals =
		{ 3, std::vector { sorts.size(), std::vector<int64_t>(lengths.size(), 0) } };
	for ( uint32_t k = 0; k < lengths.size(); ++k ) {
		const int32_t n = lengths[k];
		std::vector<std::vector<int32_t>> sequences = { ones(n), ascending(n), random(n) };
		for ( uint32_t repetition = 0; repetition < repetitions; ++repetition ) {
			for ( uint32_t i = 0; i < sequences.size(); ++i ) {
				for ( uint32_t j = 0; j < sorts.size(); ++j ) {
					totals[i][j][k] += measure_execution_time(sorts[j], sequences[i]);
				}
			}
		}
	}

	std::cout << "All timings in microseconds." << "\n\n";
	std::cout << "Sequence length";
	for ( const uint32_t& length : lengths ) {
		std::cout << std::setw(10) << length;
	}
	std::cout << "\n\n";

	for ( uint32_t i = 0; i < sequence_titles.size(); ++i ) {
		std::cout << "  " + sequence_titles[i] + ":" << "\n";
		for ( uint32_t j = 0; j < sorts.size(); ++j ) {
			std::cout << "    " + sort_titles[j] + "     ";
			for ( uint32_t k = 0; k < lengths.size(); ++k ) {
				const int64_t execution_time = totals[i][j][k] / repetitions;
				std::cout << std::setw(10) << execution_time;
			}
			std::cout << "\n";
		}
		std::cout << "\n\n";
	}
}
