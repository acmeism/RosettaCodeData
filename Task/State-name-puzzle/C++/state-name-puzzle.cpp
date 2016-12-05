#include <algorithm>
#include <iostream>
#include <string>
#include <array>
#include <vector>

template<typename T>
T unique(T&& src)
{
    T retval(std::move(src));
    std::sort(retval.begin(), retval.end(), std::less<typename T::value_type>());
    retval.erase(std::unique(retval.begin(), retval.end()), retval.end());
    return retval;
}

#define USE_FAKES 1

auto states = unique(std::vector<std::string>({
#if USE_FAKES
    "Slender Dragon", "Abalamara",
#endif
    "Alabama", "Alaska", "Arizona", "Arkansas",
    "California", "Colorado", "Connecticut",
    "Delaware",
    "Florida", "Georgia", "Hawaii",
    "Idaho", "Illinois", "Indiana", "Iowa",
    "Kansas", "Kentucky", "Louisiana",
    "Maine", "Maryland", "Massachusetts", "Michigan",
    "Minnesota", "Mississippi", "Missouri", "Montana",
    "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota",
    "Ohio", "Oklahoma", "Oregon",
    "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas",
    "Utah", "Vermont", "Virginia",
    "Washington", "West Virginia", "Wisconsin", "Wyoming"
}));

struct counted_pair
{
    std::string name;
    std::array<int, 26> count{};

    void count_characters(const std::string& s)
    {
        for (auto&& c : s) {
            if (c >= 'a' && c <= 'z') count[c - 'a']++;
            if (c >= 'A' && c <= 'Z') count[c - 'A']++;
        }
    }

    counted_pair(const std::string& s1, const std::string& s2)
        : name(s1 + " + " + s2)
    {
        count_characters(s1);
        count_characters(s2);
    }
};

bool operator<(const counted_pair& lhs, const counted_pair& rhs)
{
    auto lhs_size = lhs.name.size();
    auto rhs_size = rhs.name.size();
    return lhs_size == rhs_size
            ? std::lexicographical_compare(lhs.count.begin(),
                                           lhs.count.end(),
                                           rhs.count.begin(),
                                           rhs.count.end())
            : lhs_size < rhs_size;
}

bool operator==(const counted_pair& lhs, const counted_pair& rhs)
{
    return lhs.name.size() == rhs.name.size() && lhs.count == rhs.count;
}

int main()
{
    const int n_states = states.size();

    std::vector<counted_pair> pairs;
    for (int i = 0; i < n_states; i++) {
        for (int j = 0; j < i; j++) {
            pairs.emplace_back(counted_pair(states[i], states[j]));
        }
    }
    std::sort(pairs.begin(), pairs.end());

    auto start = pairs.begin();
    while (true) {
        auto match = std::adjacent_find(start, pairs.end());
        if (match == pairs.end()) {
            break;
        }
        auto next = match + 1;
        std::cout << match->name << " => " << next->name << "\n";
        start = next;
    }
}
