#include <algorithm>
#include <cstdint>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

const std::vector<std::string> all_colours = { "PINK", "ORANGE", "CYAN", "YELLOW", "RED", "GREEN", "BLUE" };

class Node {
public:
	Node(const int32_t& aID, const int32_t& aSaturation, const std::string& aColour)
	: id(aID), saturation(aSaturation), colour(aColour) {}

	Node() : id(0), saturation(0), colour("NO_COLOUR") {}

	int32_t id, saturation;
	std::string colour;
	bool excluded_from_search = false;
};

int main() {
	std::map<int32_t, Node, decltype([](const int32_t& a, const int32_t& b){ return a < b; })> graph;

	std::map<int32_t, std::set<int32_t, decltype([](const int32_t& a, const int32_t& b) { return a < b; })>,
		decltype([](const int32_t& a, const int32_t& b) { return a < b; })> neighbours;

	const std::vector<std::string> graph_representations = { "0-1 1-2 2-0 3",
															 "1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7",
															 "1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6",
															 "1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7" };

	for ( const std::string& graph_representation : graph_representations ) {
		graph.clear();
		neighbours.clear();
		std::stringstream stream(graph_representation);
		std::string element;
		while ( stream >> element ) {
			if ( element.find("-") != std::string::npos ) {
				const int32_t id1 = element[0] - '0';
				const int32_t id2 = element[element.length() - 1] - '0';

				if ( ! graph.contains(id1) ) {
					graph[id1] = Node(id1, 0, "NO_COLOUR");
				}
				Node node1 = graph[id1];

				if ( ! graph.contains(id2) ) {
					graph[id2] = Node(id2, 0, "NO_COLOUR");
				}
				Node node2 = graph[id2];

				neighbours[id1].emplace(id2);
				neighbours[id2].emplace(id1);
			} else {
				const int32_t id = element[0] - '0';
				if ( ! graph.contains(id) ) {
					graph[id] = Node(id, 0, "NO_COLOUR");
				}
			}
		}

		for ( uint64_t i = 0; i < graph.size(); ++i ) {
			int32_t max_node_id = -1;
			int32_t max_saturation = -1;
			for ( const auto& [key, value] : graph ) {
				if ( ! value.excluded_from_search && value.saturation > max_saturation ) {
					max_saturation = value.saturation;
					max_node_id = key;
				}
			}

			std::unordered_set<std::string> colours_used;
			for ( const int32_t& neighbour : neighbours[max_node_id] ) {
				colours_used.emplace(graph[neighbour].colour);
			}

			std::string min_colour;
			for ( const std::string& colour : all_colours ) {
				if ( ! colours_used.contains(colour) ) {
					min_colour = colour;
				}
			}

			graph[max_node_id].excluded_from_search = true;
			graph[max_node_id].colour = min_colour;

			for ( int32_t neighbour : neighbours[max_node_id] ) {
				if ( graph[neighbour].colour == "NO_COLOUR" ) {
					graph[neighbour].saturation = colours_used.size();
				}
			}
		}

		std::unordered_set<std::string> graph_colours;
		for ( const auto& [key, value] : graph ) {
			graph_colours.emplace(value.colour);
			std::cout << "Node " << key << ":   colour = " + value.colour;

			if ( ! neighbours[key].empty() ) {
				std::cout << std::string(8 - value.colour.length(), ' ') << "neighbours = ";
				for ( const int32_t& neighbour : neighbours[key] ) {
					std::cout << neighbour << " ";
				}
			}
			std::cout << std::endl;
		}
		std::cout << "Number of colours used: " << graph_colours.size() << std::endl << std::endl;
	}
}
