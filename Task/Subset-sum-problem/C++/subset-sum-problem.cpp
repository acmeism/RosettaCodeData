#include <iostream>
#include <vector>

std::ostream& operator<<(std::ostream& out, const std::string& str) {
    return out << str.c_str();
}

std::vector<std::pair<std::string, int>> items{
    {"alliance",     -624},
    {"archbishop",   -915},
    {"balm",          397},
    {"bonnet",        452},
    {"brute",         870},
    {"centipede",    -658},
    {"cobol",         362},
    {"covariate",     590},
    {"departure",     952},
    {"deploy",         44},
    {"diophantine",   645},
    {"efferent",       54},
    {"elysee",       -326},
    {"eradicate",     376},
    {"escritoire",    856},
    {"exorcism",     -983},
    {"fiat",          170},
    {"filmy",        -874},
    {"flatworm",      503},
    {"gestapo",       915},
    {"infra",        -847},
    {"isis",         -982},
    {"lindholm",      999},
    {"markham",       475},
    {"mincemeat",    -880},
    {"moresby",       756},
    {"mycenae",       183},
    {"plugging",     -266},
    {"smokescreen",   423},
    {"speakeasy",    -745},
    {"vein",          813},
};

std::vector<int> indices;
int count = 0;
const int LIMIT = 5;

void subsum(int i, int weight) {
    if (i != 0 && weight == 0) {
        for (int j = 0; j < i; ++j) {
            auto item = items[indices[j]];
            std::cout << (j ? " " : "") << item.first;
        }
        std::cout << '\n';
        if (count < LIMIT) count++;
        else return;
    }
    int k = (i != 0) ? indices[i - 1] + 1 : 0;
    for (int j = k; j < items.size(); ++j) {
        indices[i] = j;
        subsum(i + 1, weight + items[j].second);
        if (count == LIMIT) return;
    }
}

int main() {
    indices.resize(items.size());
    subsum(0, 0);
    return 0;
}
