#include <iostream>
#include <vector>
#include <algorithm>
#include <string>

typedef std::pair<int32_t, int32_t> Edge;

std::string to_string(const int32_t& value) {
	return std::to_string(value);
}

std::string to_string(const Edge& edge) {
	return "(" + std::to_string(edge.first) + ", " + std::to_string(edge.second) + ")";
}

template <typename T>
std::string vector_to_string(const std::vector<T>& list) {
	std::string result = "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		result += to_string(list[i]) + ", ";
	}
	result += to_string(list.back()) + "]";
	return result;
}

bool is_same_face(const std::vector<int32_t>& list_1, const std::vector<int32_t>& list_2) {
	if ( list_1.size() != list_2.size() || list_1.empty() ) {
		return false;
	}

	std::vector<int32_t> copy_2(list_2);
	for ( int32_t i = 0; i < 2; ++i ) {
		int32_t start;
		if ( auto iterator = std::find(copy_2.begin(), copy_2.end(), list_1.front()); iterator != copy_2.end() ) {
			start = std::distance(copy_2.begin(), iterator);
		} else {
			return false;
		}
		std::vector<int32_t> test(copy_2.begin() + start, copy_2.end());
		test.insert(test.end(), copy_2.begin(), copy_2.begin() + start);//addAll(copyTwo.subList(0, start));
		if ( list_1 == test ) {
			return true;
		}
		std::reverse(copy_2.begin(), copy_2.end());
	}

	return false;
}

std::vector<int32_t> to_perimeter_format_face(const std::vector<Edge>& edge_format_face) {
	if ( edge_format_face.empty() ) {
		return std::vector<int32_t>();
	}

	std::vector<Edge> edges(edge_format_face);
	std::vector<int32_t> result;
	Edge first_edge = edges.front();
	edges.erase(edges.begin());
	int next_vertex = first_edge.first;
	result.push_back(next_vertex);

	while ( ! edges.empty() ) {
		int32_t index = -1;
		for ( Edge edge : edges ) {
			if ( edge.first == next_vertex || edge.second == next_vertex ) {
				if ( auto iterator = std::find(edges.begin(), edges.end(), edge); iterator != edges.end() ) {
					index = std::distance(edges.begin(), iterator);
				}
				next_vertex = ( next_vertex == edge.first ) ? edge.second : edge.first;
				break;
			}
		}
		if ( index == -1 ) {
			return std::vector<int32_t>();
		}
		result.push_back(next_vertex);
		edges.erase(edges.begin() + index);
	}

	if ( next_vertex != first_edge.second ) {
		return std::vector<int32_t>();
	}
	return result;
}

int main() {
	const std::vector<int32_t> perimeter_format_q = { 8, 1, 3 };
	const std::vector<int32_t> perimeter_format_r = { 1, 3, 8 };
	const std::vector<int32_t> perimeter_format_u = { 18, 8, 14, 10, 12, 17, 19 };
	const std::vector<int32_t> perimeter_format_v = { 8, 14, 10, 12, 17, 19, 18 };

	const std::vector<Edge> edge_format_e = { Edge(1, 11), Edge(7, 11), Edge(1, 7) };
	const std::vector<Edge> edge_format_f = { Edge(11, 23), Edge(1, 17), Edge(17, 23), Edge(1, 11) };
	const std::vector<Edge> edge_format_g =
		{ Edge(8, 14), Edge(17, 19), Edge(10, 12), Edge(10, 14), Edge(12, 17), Edge(8, 18), Edge(18, 19) };
	const std::vector<Edge> edge_format_h = { Edge(1, 3), Edge(9, 11), Edge(3, 11), Edge(1, 11) };

	std::cout << "PerimeterFormat equality checks:" << std::endl;
	bool same_face = is_same_face(perimeter_format_q, perimeter_format_r);
	std::cout << vector_to_string(perimeter_format_q) << " == "
			  << vector_to_string(perimeter_format_r) << ": " << std::boolalpha << same_face << std::endl;
	same_face = is_same_face(perimeter_format_u, perimeter_format_v);
	std::cout << vector_to_string(perimeter_format_u) << " == "
			  << vector_to_string(perimeter_format_v) << ": " << std::boolalpha << same_face << std::endl;

	std::cout << "\nEdgeFormat to PerimeterFormat conversions:" << std::endl;
	std::vector<std::vector<Edge>> edge_format_faces = { edge_format_e, edge_format_f, edge_format_g, edge_format_h };
	for ( std::vector<Edge> edge_format_face : edge_format_faces ) {
		std::vector<int32_t> perimeter_format_face = to_perimeter_format_face(edge_format_face);
		if ( perimeter_format_face.empty() ) {
			std::cout << vector_to_string(edge_format_face) << " has invalid edge format" << std::endl;
		} else {
			std::cout << vector_to_string(edge_format_face) << " => "
					  << vector_to_string(perimeter_format_face) << std::endl;
		}
	}
}
