#include <algorithm>
#include <iostream>
#include <vector>
using namespace std;

const vector<string> MONTHS = {
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};

struct Birthday {
    int month, day;

    friend ostream &operator<<(ostream &, const Birthday &);
};

ostream &operator<<(ostream &out, const Birthday &birthday) {
    return out << MONTHS[birthday.month - 1] << ' ' << birthday.day;
}

template <typename C>
bool monthUniqueIn(const Birthday &b, const C &container) {
    auto it = cbegin(container);
    auto end = cend(container);
    int count = 0;
    while (it != end) {
        if (it->month == b.month) {
            count++;
        }
        it = next(it);
    }
    return count == 1;
}

template <typename C>
bool dayUniqueIn(const Birthday &b, const C &container) {
    auto it = cbegin(container);
    auto end = cend(container);
    int count = 0;
    while (it != end) {
        if (it->day == b.day) {
            count++;
        }
        it = next(it);
    }
    return count == 1;
}

template <typename C>
bool monthWithUniqueDayIn(const Birthday &b, const C &container) {
    auto it = cbegin(container);
    auto end = cend(container);
    while (it != end) {
        if (it->month == b.month && dayUniqueIn(*it, container)) {
            return true;
        }
        it = next(it);
    }
    return false;
}

int main() {
    vector<Birthday> choices = {
        {5, 15}, {5, 16}, {5, 19}, {6, 17}, {6, 18},
        {7, 14}, {7, 16}, {8, 14}, {8, 15}, {8, 17},
    };

    // Albert knows the month but doesn't know the day.
    // So the month can't be unique within the choices.
    vector<Birthday> filtered;
    for (auto bd : choices) {
        if (!monthUniqueIn(bd, choices)) {
            filtered.push_back(bd);
        }
    }

    // Albert also knows that Bernard doesn't know the answer.
    // So the month can't have a unique day.
    vector<Birthday> filtered2;
    for (auto bd : filtered) {
        if (!monthWithUniqueDayIn(bd, filtered)) {
            filtered2.push_back(bd);
        }
    }

    // Bernard now knows the answer.
    // So the day must be unique within the remaining choices.
    vector<Birthday> filtered3;
    for (auto bd : filtered2) {
        if (dayUniqueIn(bd, filtered2)) {
            filtered3.push_back(bd);
        }
    }

    // Albert now knows the answer too.
    // So the month must be unique within the remaining choices.
    vector<Birthday> filtered4;
    for (auto bd : filtered3) {
        if (monthUniqueIn(bd, filtered3)) {
            filtered4.push_back(bd);
        }
    }

    if (filtered4.size() == 1) {
        cout << "Cheryl's birthday is " << filtered4[0] << '\n';
    } else {
        cout << "Something went wrong!\n";
    }

    return 0;
}
