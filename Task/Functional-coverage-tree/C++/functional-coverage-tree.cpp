#include <cstdint>
#include <iomanip>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

class FCNode {
public:
	FCNode(const std::string& name, const uint32_t& weight, const double& coverage)
	: name(name), weight(weight), coverage(coverage), parent(NULL) {}

	void add_children(const std::vector<std::shared_ptr<FCNode>>& nodes) {
		for ( const std::shared_ptr<FCNode>& node : nodes ) {
			node->parent = this;
			children.emplace_back(node);
			update_coverage();
		}
	}
	
	double get_coverage() {
		return coverage;
	}

	void set_coverage(const double& aCoverage) {
		if ( coverage != aCoverage ) {
			coverage = aCoverage;
			if ( parent ) {
				parent->update_coverage();
			}
		}
	}

	void display() {
		display(0);
	}

private:
	void update_coverage() {
		double sum_weighted_coverage = 0.0;
		uint32_t sum_weight = 0;
		for ( const std::shared_ptr<FCNode>& node : children ) {
			sum_weighted_coverage += node->weight * node->coverage;
			sum_weight += node->weight;
		}

		set_coverage(sum_weighted_coverage / sum_weight);
	}

	void display(uint32_t level) {
		const std::string initial = std::string(4 * level, ' ') + name;
		const std::string padding = std::string(NAME_FIELD_WIDTH - initial.length(), ' ');
		std::cout << initial + padding + "|";
		std::cout << "  " << std::setw(3) << weight << "   |";
		std::cout << " " << std::fixed << std::setprecision(6) << coverage << " |" << std::endl;

		for ( const std::shared_ptr<FCNode>& child : children ) {
			child->display(level + 1);
		}
	}

	std::string name;
	uint32_t weight;
	double coverage;
	FCNode* parent;
	std::vector<std::shared_ptr<FCNode>> children{ };

	static constexpr uint32_t NAME_FIELD_WIDTH = 32;
};

int main() {
	FCNode cleaning("Cleaning", 1, 0.0);

	std::vector<std::shared_ptr<FCNode>> houses = {
		std::make_shared<FCNode>("House_1", 40, 0.0),
		std::make_shared<FCNode>("House_2", 60, 0.0)
	};
	cleaning.add_children(houses);

	std::vector<std::shared_ptr<FCNode>> house_1 = {
		std::make_shared<FCNode>("Bedrooms", 1, 0.25),
		std::make_shared<FCNode>("Bathrooms", 1, 0.0),
		std::make_shared<FCNode>("Attic", 1, 0.75),
		std::make_shared<FCNode>("Kitchen", 1, 0.1),
		std::make_shared<FCNode>("Living_rooms", 1, 0.0),
		std::make_shared<FCNode>("Basement", 1, 0.0),
		std::make_shared<FCNode>("Garage", 1, 0.0),
		std::make_shared<FCNode>("Garden",1, 0.8)
	};
	houses[0]->add_children(house_1);

	std::vector<std::shared_ptr<FCNode>> bathrooms_house_1 = {
		std::make_shared<FCNode>("Bathroom_1", 1, 0.5),
		std::make_shared<FCNode>("Bathroom_2", 1, 0.0),
		std::make_shared<FCNode>("Outside_lavatory", 1, 1.0)
	};
	house_1[1]->add_children(bathrooms_house_1);

	std::vector<std::shared_ptr<FCNode>> living_rooms_house_1 = {
		std::make_shared<FCNode>("lounge", 1, 0.0),
		std::make_shared<FCNode>("Dining_room", 1, 0.0),
		std::make_shared<FCNode>("Conservatory", 1, 0.0),
		std::make_shared<FCNode>("Playroom", 1, 1.0)
	};
	house_1[4]->add_children(living_rooms_house_1);

	std::vector<std::shared_ptr<FCNode>> house_2 = {
		std::make_shared<FCNode>("Upstairs", 1, 0.15),
		std::make_shared<FCNode>("Ground_floor", 1, 0.316667),
		std::make_shared<FCNode>("Basement", 1, 0.916667)
	};
	houses[1]->add_children(house_2);

	std::vector<std::shared_ptr<FCNode>> upstairs = {
		std::make_shared<FCNode>("Bedrooms", 1, 0.0),
		std::make_shared<FCNode>("Bathroom", 1, 0.0),
		std::make_shared<FCNode>("Toilet", 1, 0.0),
		std::make_shared<FCNode>("Attics", 1, 0.6)
	};
	house_2[0]->add_children(upstairs);

	std::vector<std::shared_ptr<FCNode>> ground_floor = {
		std::make_shared<FCNode>("Kitchen", 1, 0.0),
		std::make_shared<FCNode>("Living_rooms", 1, 0.0),
		std::make_shared<FCNode>("Wet_room_&_toilet", 1, 0.0),
		std::make_shared<FCNode>("Garage", 1, 0.0),
		std::make_shared<FCNode>("Garden", 1, 0.9),
		std::make_shared<FCNode>("Hot_tub_suite", 1, 1.0)
	};
    house_2[1]->add_children(ground_floor);

    std::vector<std::shared_ptr<FCNode>> basement = {
		std::make_shared<FCNode>("Cellars", 1, 1.0),
		std::make_shared<FCNode>("Wine_cellar", 1, 1.0),
		std::make_shared<FCNode>("Cinema", 1, 0.75)
    };
    house_2[2]->add_children(basement);

    std::vector<std::shared_ptr<FCNode>> bedrooms = {
		std::make_shared<FCNode>("Suite_1", 1, 0.0),
		std::make_shared<FCNode>("Suite_2", 1, 0.0),
		std::make_shared<FCNode>("Bedroom_3",1, 0.0),
		std::make_shared<FCNode>("Bedroom_4",1, 0.0)
    };
    upstairs[0]->add_children(bedrooms);

    std::vector<std::shared_ptr<FCNode>> living_rooms_house_2 = {
		std::make_shared<FCNode>("lounge", 1, 0.0),
		std::make_shared<FCNode>("Dining_room", 1, 0.0),
		std::make_shared<FCNode>("Conservatory", 1, 0.0),
		std::make_shared<FCNode>("Playroom", 1, 0.0)
    };
    ground_floor[1]->add_children(living_rooms_house_2);

    const double overall_coverage = cleaning.get_coverage();
	std::cout << "OVERALL COVERAGE = " << std::fixed << std::setprecision(6)
			  << overall_coverage << std::endl << std::endl;
	std::cout << "NAME HIERARCHY                  | WEIGHT | COVERAGE |" << std::endl;
	std::cout << "--------------------------------|--------|----------|" << std::endl;
	cleaning.display();
	std::cout << std::endl;

	basement[2]->set_coverage(1.0); // Change House_2 Cinema node coverage to 1.0
	const double updated_coverage = cleaning.get_coverage();
	const double difference = updated_coverage - overall_coverage;
	std::cout << "If the coverage of the House_2 Cinema node were increased " << std::endl;
	std::cout << "from 0.75 to 1.0 the overall coverage would increase by ";
	std::cout << std::fixed << std::setprecision(6) << difference << " to " << updated_coverage << std::endl;
	basement[2]->set_coverage(0.75); // Restore to House_2 Cinema node coverage to its original value
}
