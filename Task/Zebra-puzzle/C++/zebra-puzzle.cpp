#include <stdio.h>
#include <string.h>

#define defenum(name, val0, val1, val2, val3, val4) \
    enum name { val0, val1, val2, val3, val4 }; \
    const char *name ## _str[] = { # val0, # val1, # val2, # val3, # val4 }

defenum( Attrib,    Color, Man, Drink, Animal, Smoke );
defenum( Colors,    Red, Green, White, Yellow, Blue );
defenum( Mans,      English, Swede, Dane, German, Norwegian );
defenum( Drinks,    Tea, Coffee, Milk, Beer, Water );
defenum( Animals,   Dog, Birds, Cats, Horse, Zebra );
defenum( Smokes,    PallMall, Dunhill, Blend, BlueMaster, Prince );

void printHouses(int ha[5][5]) {
    const char **attr_names[5] = {Colors_str, Mans_str, Drinks_str, Animals_str, Smokes_str};

    printf("%-10s", "House");
    for (const char *name : Attrib_str) printf("%-10s", name);
    printf("\n");

    for (int i = 0; i < 5; i++) {
        printf("%-10d", i);
        for (int j = 0; j < 5; j++) printf("%-10s", attr_names[j][ha[i][j]]);
        printf("\n");
    }
}

struct HouseNoRule {
    int houseno;
    Attrib a; int v;
} housenos[] = {
    {2, Drink, Milk},     // Cond 9: In the middle house they drink milk.
    {0, Man, Norwegian}   // Cond 10: The Norwegian lives in the first house.
};

struct AttrPairRule {
    Attrib a1; int v1;
    Attrib a2; int v2;

    bool invalid(int ha[5][5], int i) {
        return (ha[i][a1] >= 0 && ha[i][a2] >= 0) &&
               ((ha[i][a1] == v1 && ha[i][a2] != v2) ||
                (ha[i][a1] != v1 && ha[i][a2] == v2));
    }
} pairs[] = {
    {Man, English,      Color, Red},     // Cond 2: The English man lives in the red house.
    {Man, Swede,        Animal, Dog},    // Cond 3: The Swede has a dog.
    {Man, Dane,         Drink, Tea},     // Cond 4: The Dane drinks tea.
    {Color, Green,      Drink, Coffee},  // Cond 6: drink coffee in the green house.
    {Smoke, PallMall,   Animal, Birds},  // Cond 7: The man who smokes Pall Mall has birds.
    {Smoke, Dunhill,    Color, Yellow},  // Cond 8: In the yellow house they smoke Dunhill.
    {Smoke, BlueMaster, Drink, Beer},    // Cond 13: The man who smokes Blue Master drinks beer.
    {Man, German,       Smoke, Prince}    // Cond 14: The German smokes Prince
};

struct NextToRule {
    Attrib a1; int v1;
    Attrib a2; int v2;

    bool invalid(int ha[5][5], int i) {
        return (ha[i][a1] == v1) &&
               ((i == 0 && ha[i + 1][a2] >= 0 && ha[i + 1][a2] != v2) ||
                (i == 4 && ha[i - 1][a2] != v2) ||
                (ha[i + 1][a2] >= 0 && ha[i + 1][a2] != v2 && ha[i - 1][a2] != v2));
    }
} nexttos[] = {
    {Smoke, Blend,      Animal, Cats},    // Cond 11: The man who smokes Blend lives in the house next to the house with cats.
    {Smoke, Dunhill,    Animal, Horse},   // Cond 12: In a house next to the house where they have a horse, they smoke Dunhill.
    {Man, Norwegian,    Color, Blue},     // Cond 15: The Norwegian lives next to the blue house.
    {Smoke, Blend,      Drink, Water}     // Cond 16: They drink water in a house next to the house where they smoke Blend.
};

struct LeftOfRule {
    Attrib a1; int v1;
    Attrib a2; int v2;

    bool invalid(int ha[5][5]) {
        return (ha[0][a2] == v2) || (ha[4][a1] == v1);
    }

    bool invalid(int ha[5][5], int i) {
        return ((i > 0 && ha[i][a1] >= 0) &&
                ((ha[i - 1][a1] == v1 && ha[i][a2] != v2) ||
                 (ha[i - 1][a1] != v1 && ha[i][a2] == v2)));
    }
} leftofs[] = {
    {Color, Green,  Color, White}     // Cond 5: The green house is immediately to the left of the white house.
};

bool invalid(int ha[5][5]) {
    for (auto &rule : leftofs) if (rule.invalid(ha)) return true;

    for (int i = 0; i < 5; i++) {
#define eval_rules(rules) for (auto &rule : rules) if (rule.invalid(ha, i)) return true;
        eval_rules(pairs);
        eval_rules(nexttos);
        eval_rules(leftofs);
    }
    return false;
}

void search(bool used[5][5], int ha[5][5], const int hno, const int attr) {
    int nexthno, nextattr;
    if (attr < 4) {
        nextattr = attr + 1;
        nexthno = hno;
    } else {
        nextattr = 0;
        nexthno = hno + 1;
    }

    if (ha[hno][attr] != -1) {
        search(used, ha, nexthno, nextattr);
    } else {
        for (int i = 0; i < 5; i++) {
            if (used[attr][i]) continue;
            used[attr][i] = true;
            ha[hno][attr] = i;

            if (!invalid(ha)) {
                if ((hno == 4) && (attr == 4)) {
                    printHouses(ha);
                } else {
                    search(used, ha, nexthno, nextattr);
                }
            }

            used[attr][i] = false;
        }
        ha[hno][attr] = -1;
    }
}

int main() {
    bool used[5][5] = {};
    int ha[5][5]; memset(ha, -1, sizeof(ha));

    for (auto &rule : housenos) {
        ha[rule.houseno][rule.a] = rule.v;
        used[rule.a][rule.v] = true;
    }

    search(used, ha, 0, 0);

    return 0;
}
