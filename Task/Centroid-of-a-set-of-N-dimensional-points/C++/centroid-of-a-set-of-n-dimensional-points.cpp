#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]";
}

template <typename T>
void print_2D_vector(const std::vector<std::vector<T>>& vecs) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vecs.size() - 1; ++i ) {
		print_vector(vecs[i]); std::cout << ", ";
	}
	print_vector(vecs.back()); std::cout << "]";
}

bool all_same_size(const std::vector<std::vector<double>>& points, const uint32_t& dimension) {
	for ( uint32_t i = 1; i < points.size(); ++i ) {
		if ( points[i].size() != dimension ) {
			return false;
		}
	}
	return true;
}

std::vector<double> centroid(const std::vector<std::vector<double>>& points) {
	if ( points.empty() ) {
		throw std::invalid_argument("Vector must contain at least one point.");
	}

	const uint32_t dimension = points[0].size();
	if ( ! all_same_size(points, dimension) ) {
		throw std::invalid_argument("Points must all have the same dimension.");
	}

	std::vector<double> result(dimension, 0.0);
	for ( uint32_t j = 0; j < dimension; ++j ) {
		for ( uint32_t i = 0; i < points.size(); ++i ) {
			result[j] += points[i][j];
		}
		result[j] /= points.size();
	}
	return result;
}

int main() {
	std::vector<std::vector<std::vector<double>>> vector_points = {
		std::vector{ std::vector{ 1.0 }, std::vector{ 2.0 }, std::vector{ 3.0 } },
		std::vector{ std::vector{ 8.0, 2.0 }, std::vector{ 0.0, 0.0 } },
		std::vector{ std::vector{ 5.0, 5.0, 0.0 }, std::vector{ 10.0, 10.0, 0.0 } },
		std::vector{ std::vector{ 1.0, 3.1, 6.5 }, std::vector{ -2.0, -5.0, 3.4 },
				     std::vector{ -7.0, -4.0, 9.0 }, std::vector{ 2.0, 0.0, 3.0 } },
		std::vector{ std::vector{ 0.0, 0.0, 0.0, 0.0, 1.0 }, std::vector{ 0.0, 0.0, 0.0, 1.0, 0.0 },
				     std::vector{ 0.0, 0.0, 1.0, 0.0, 0.0 }, std::vector{ 0.0, 1.0, 0.0, 0.0, 0.0 } }
	};

	for ( const std::vector<std::vector<double>>& points : vector_points ) {
		print_2D_vector(points); std::cout << " => Centroid: "; print_vector(centroid(points)); std::cout << std::endl;
	}
}
