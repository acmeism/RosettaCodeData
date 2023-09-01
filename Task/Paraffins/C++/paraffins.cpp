#include <cstdint>
#include <iostream>
#include <vector>

const int32_t MAX_TREE_NODES = 52;
const int32_t MAX_BRANCHES = 4;

std::vector<uint64_t> rooted(MAX_TREE_NODES + 1, 0);
std::vector<uint64_t> unrooted(MAX_TREE_NODES + 1,0);
std::vector<uint64_t> count(MAX_BRANCHES, 0);

void tree(const int32_t& branches, const int32_t& radius, const int32_t& combinations,
		  const int32_t& previous_nodes, const uint64_t& branches_count) {
	
	int32_t nodes = previous_nodes;
	for ( int32_t branch = branches + 1; branch <= MAX_BRANCHES; ++branch ) {
		nodes += radius;

		if ( nodes > MAX_TREE_NODES || ( combinations * 2 >= nodes && branch >= MAX_BRANCHES ) ) {
			return;
		}

		if ( branch == branches + 1 ) {
			count[branches] = rooted[radius] * branches_count;
		} else {
			count[branches] *= ( rooted[radius] + branch - branches - 1 );
			count[branches] /= ( branch - branches );
		}

		if ( combinations * 2 < nodes ) {
			unrooted[nodes] += count[branches];
		}

		if ( branch < MAX_BRANCHES ) {
			rooted[nodes] += count[branches];
		}

		for ( int32_t next_radius = radius - 1; next_radius > 0; --next_radius ) {
			tree(branch, next_radius, combinations, nodes, count[branches]);
		}
	}
}

void bicenter(const int32_t& node) {
	if ( ( node & 1 ) == 0 ) {
		const uint64_t temp = ( rooted[node / 2] + 1 ) * rooted[node / 2];
		unrooted[node] += temp / 2;
	}
}

int main() {
	rooted[0] = rooted[1] = 1;
	unrooted[0] = unrooted[1] = 1;

	for ( int32_t node = 1; node <= MAX_TREE_NODES; ++node ) {
		tree(0, node, node, 1, 1);
		bicenter(node);
		std::cout << node << ": " << unrooted[node] << std::endl;
	}
}
