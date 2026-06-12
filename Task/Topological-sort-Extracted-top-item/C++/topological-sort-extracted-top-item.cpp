#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <map>
#include <set>
#include <string>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]" << std::endl;
}

template <typename T>
void print_set(const std::set<T>& a_set) {
	for ( auto iter = a_set.begin(); iter != a_set.end(); ) {
	    std::cout << *iter;
	    if ( ++iter != a_set.end() ) {
	    	std::cout << ", ";
	    }
	}
}

// Return the top levels of the dependency graph
std::set<std::string> top_levels(const std::map<std::string, std::set<std::string>>& data) {
	// Remove self dependencies
	for ( auto [key, value] : data ) {
		value.erase(key);
    }

	std::vector<std::string> dependencies{ };
	for ( auto [key, value] : data ) {
		dependencies.insert(dependencies.end(), value.begin(), value.end());
	}

	std::set<std::string> result{ };
	for ( const auto& [key, value] : data ) {
		result.insert(key);
	}

	for ( const std::string& dependency : dependencies ) {
		result.erase(dependency);
	}
	return result;
}

// Return the set of top level items in topological order
std::vector<std::vector<std::string>> top_extraction(std::map<std::string, std::set<std::string>> data,
										             std::set<std::string> tops) {
	// Remove self dependencies
	for ( auto [key, value] : data ) {
		value.erase(key);
	}

	std::set<std::string> dependencies{ };
	std::vector<std::set<std::string>> cumulative_dependencies{ };

	do {
		cumulative_dependencies.emplace_back(tops);

		dependencies.clear();
		for ( const std::string& element : tops ) {
			if ( data.contains(element) ) {
				dependencies.insert(data[element].begin(), data[element].end());
			}
		}
		tops = dependencies;
	} while ( ! dependencies.empty() );

	std::vector<std::vector<std::string>> result{ };
	std::set<std::string> accumulator{ };
	for ( int32_t i = cumulative_dependencies.size() - 1; i >= 0; --i ) {
		for ( std::string accum : accumulator ) {
			cumulative_dependencies[i].erase(accum);
		}
		std::vector<std::string> cumulative_dependencies_vec(
			cumulative_dependencies[i].begin(), cumulative_dependencies[i].end());
		std::sort(cumulative_dependencies_vec.begin(), cumulative_dependencies_vec.end());

		result.emplace_back(cumulative_dependencies_vec);
		accumulator.insert(cumulative_dependencies[i].begin(), cumulative_dependencies[i].end());
	}

	return result;
}

void print_compilation_order(const std::vector<std::vector<std::string>>& order) {
  if ( ! order.empty() ) {
      std::cout << "First: "; print_vector(order[0]);
  }
  for ( uint32_t i = 1; i < order.size(); ++i ) {
      std::cout << "    Then: "; print_vector(order[i]);
  }
  std::cout << std::endl;
}

int main() {
	const std::map<std::string, std::set<std::string>> data = {
		{ "top1",  std::set<std::string>{ "ip1", "des1", "ip2" } },
		{ "top2",  std::set<std::string>{ "ip2", "des1", "ip3" } },
		{ "des1",  std::set<std::string>{ "des1a", "des1b", "des1c" } },
		{ "des1a", std::set<std::string>{ "des1a1", "des1a2" } },
		{ "des1c", std::set<std::string>{ "des1c1", "extra1" } },
		{ "ip2",   std::set<std::string>{ "ip2a", "ip2b", "ip2c", "ipcommon" } },
		{ "ip1",   std::set<std::string>{ "ip1a", "ipcommon", "extra1" } }
 	};

	std::set<std::string> tops = top_levels(data);
	std::cout << "The top levels of the dependency graph are: "; print_set(tops); std::cout << std::endl << std::endl;

	for ( const std::string& top : tops ) {
	    std::cout << "The compilation order for top level '" << top << "' is:" << std::endl;
	    print_compilation_order(top_extraction(data, { top }));
	}

	if ( tops.size() > 1 ) {
	    std::cout << "The compilation order for top levels '"; print_set(tops); std::cout << "' is:" << std::endl;
	    print_compilation_order(top_extraction(data, tops));
	}

	const std::string ip1 = "ip1";
	std::cout << "The compilation order for file '" << ip1 << "' is:" << std::endl;
	print_compilation_order(top_extraction(data, { ip1 }));
}
