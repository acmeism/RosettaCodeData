#include <iostream>
#include <string>
#include <vector>

struct last_letter_first_letter {
    size_t max_path_length = 0;
    size_t max_path_length_count = 0;
    std::vector<std::string> max_path_example;

    void search(std::vector<std::string>& names, size_t offset) {
        if (offset > max_path_length) {
            max_path_length = offset;
            max_path_length_count = 1;
            max_path_example.assign(names.begin(), names.begin() + offset);
        } else if (offset == max_path_length) {
            ++max_path_length_count;
        }
        char last_letter = names[offset - 1].back();
        for (size_t i = offset, n = names.size(); i < n; ++i) {
            if (names[i][0] == last_letter) {
                names[i].swap(names[offset]);
                search(names, offset + 1);
                names[i].swap(names[offset]);
            }
        }
    }

    void find_longest_chain(std::vector<std::string>& names) {
        max_path_length = 0;
        max_path_length_count = 0;
        max_path_example.clear();
        for (size_t i = 0, n = names.size(); i < n; ++i) {
            names[i].swap(names[0]);
            search(names, 1);
            names[i].swap(names[0]);
        }
    }
};

int main() {
    std::vector<std::string> names{"audino", "bagon", "baltoy", "banette",
        "bidoof", "braviary", "bronzor", "carracosta", "charmeleon",
        "cresselia", "croagunk", "darmanitan", "deino", "emboar",
        "emolga", "exeggcute", "gabite", "girafarig", "gulpin",
        "haxorus", "heatmor", "heatran", "ivysaur", "jellicent",
        "jumpluff", "kangaskhan", "kricketune", "landorus", "ledyba",
        "loudred", "lumineon", "lunatone", "machamp", "magnezone",
        "mamoswine", "nosepass", "petilil", "pidgeotto", "pikachu",
        "pinsir", "poliwrath", "poochyena", "porygon2", "porygonz",
        "registeel", "relicanth", "remoraid", "rufflet", "sableye",
        "scolipede", "scrafty", "seaking", "sealeo", "silcoon",
        "simisear", "snivy", "snorlax", "spoink", "starly", "tirtouga",
        "trapinch", "treecko", "tyrogue", "vigoroth", "vulpix",
        "wailord", "wartortle", "whismur", "wingull", "yamask"};
    last_letter_first_letter solver;
    solver.find_longest_chain(names);
    std::cout << "Maximum path length: " << solver.max_path_length << '\n';
    std::cout << "Paths of that length: " << solver.max_path_length_count << '\n';
    std::cout << "Example path of that length:\n  ";
    for (size_t i = 0, n = solver.max_path_example.size(); i < n; ++i) {
        if (i > 0 && i % 7 == 0)
            std::cout << "\n  ";
        else if (i > 0)
            std::cout << ' ';
        std::cout << solver.max_path_example[i];
    }
    std::cout << '\n';
}
