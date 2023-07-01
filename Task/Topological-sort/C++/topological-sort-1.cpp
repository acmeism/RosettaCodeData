#include <map>
#include <set>

template<typename Goal>
class topological_sorter {
protected:
    struct relations {
        std::size_t dependencies;
        std::set<Goal> dependents;
    };
    std::map<Goal, relations> map;
public:
    void add_goal(Goal const &goal) {
        map[goal];
    }
    void add_dependency(Goal const &goal, Goal const &dependency) {
        if (dependency == goal)
            return;
        auto &dependents = map[dependency].dependents;
        if (dependents.find(goal) == dependents.end()) {
            dependents.insert(goal);
            ++map[goal].dependencies;
        }
    }
    template<typename Container>
    void add_dependencies(Goal const &goal, Container const &dependencies) {
        for (auto const &dependency : dependencies)
            add_dependency(goal, dependency);
    }
    template<typename ResultContainer, typename CyclicContainer>
    void destructive_sort(ResultContainer &sorted, CyclicContainer &unsortable) {
        sorted.clear();
        unsortable.clear();
        for (auto const &lookup : map) {
            auto const &goal = lookup.first;
            auto const &relations = lookup.second;
            if (relations.dependencies == 0)
                sorted.push_back(goal);
        }
        for (std::size_t index = 0; index < sorted.size(); ++index)
            for (auto const &goal : map[sorted[index]].dependents)
                if (--map[goal].dependencies == 0)
                    sorted.push_back(goal);
        for (auto const &lookup : map) {
            auto const &goal = lookup.first;
            auto const &relations = lookup.second;
            if (relations.dependencies != 0)
                unsortable.push_back(goal);
        }
    }
    template<typename ResultContainer, typename CyclicContainer>
    void sort(ResultContainer &sorted, CyclicContainer &unsortable) {
        topological_sorter<Goal> temporary = *this;
        temporary.destructive_sort(sorted, unsortable);
    }
    void clear() {
        map.clear();
    }
};

/*
 Example usage with text strings
 */

#include <fstream>
#include <sstream>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

void display_heading(string const &message) {
    cout << endl << "~ " << message << " ~" << endl;
}
void display_results(string const &input) {
    topological_sorter<string> sorter;
    vector<string> sorted, unsortable;
    stringstream lines(input);
    string line;
    while (getline(lines, line)) {
        stringstream buffer(line);
        string goal, dependency;
        buffer >> goal;
        sorter.add_goal(goal);
        while (buffer >> dependency)
            sorter.add_dependency(goal, dependency);
    }
    sorter.destructive_sort(sorted, unsortable);
    if (sorted.size() == 0)
        display_heading("Error: no independent variables found!");
    else {
        display_heading("Result");
        for (auto const &goal : sorted)
            cout << goal << endl;
    }
    if (unsortable.size() != 0) {
        display_heading("Error: cyclic dependencies detected!");
        for (auto const &goal : unsortable)
            cout << goal << endl;
    }
}
int main(int argc, char **argv) {
    if (argc == 1) {
        string example = "des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee\n"
                "dw01             ieee dw01 dware gtech\n"
                "dw02             ieee dw02 dware\n"
                "dw03             std synopsys dware dw03 dw02 dw01 ieee gtech\n"
                "dw04             dw04 ieee dw01 dware gtech\n"
                "dw05             dw05 ieee dware\n"
                "dw06             dw06 ieee dware\n"
                "dw07             ieee dware\n"
                "dware            ieee dware\n"
                "gtech            ieee gtech\n"
                "ramlib           std ieee\n"
                "std_cell_lib     ieee std_cell_lib\n"
                "synopsys\n"
                "cycle_11     cycle_12\n"
                "cycle_12     cycle_11\n"
                "cycle_21     dw01 cycle_22 dw02 dw03\n"
                "cycle_22     cycle_21 dw01 dw04";
        display_heading("Example: each line starts with a goal followed by it's dependencies");
        cout << example << endl;
        display_results(example);
        display_heading("Enter lines of data (press enter when finished)");
        string line, data;
        while (getline(cin, line) && !line.empty())
            data += line + '\n';
        if (!data.empty())
            display_results(data);
    } else
        while (*(++argv)) {
            ifstream file(*argv);
            typedef istreambuf_iterator<char> iterator;
            display_results(string(iterator(file), iterator()));
        }
}
