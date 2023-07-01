#include <initializer_list>
#include <iostream>
#include <map>
#include <vector>

struct Wheel {
private:
    std::vector<char> values;
    size_t index;

public:
    Wheel() : index(0) {
        // empty
    }

    Wheel(std::initializer_list<char> data) : values(data), index(0) {
        //values.assign(data);
        if (values.size() < 1) {
            throw new std::runtime_error("Not enough elements");
        }
    }

    char front() {
        return values[index];
    }

    void popFront() {
        index = (index + 1) % values.size();
    }
};

struct NamedWheel {
private:
    std::map<char, Wheel> wheels;

public:
    void put(char c, Wheel w) {
        wheels[c] = w;
    }

    char front(char c) {
        char v = wheels[c].front();
        while ('A' <= v && v <= 'Z') {
            v = wheels[v].front();
        }
        return v;
    }

    void popFront(char c) {
        auto v = wheels[c].front();
        wheels[c].popFront();

        while ('A' <= v && v <= 'Z') {
            auto d = wheels[v].front();
            wheels[v].popFront();
            v = d;
        }
    }
};

void group1() {
    Wheel w({ '1', '2', '3' });
    for (size_t i = 0; i < 20; i++) {
        std::cout << ' ' << w.front();
        w.popFront();
    }
    std::cout << '\n';
}

void group2() {
    Wheel a({ '1', 'B', '2' });
    Wheel b({ '3', '4' });

    NamedWheel n;
    n.put('A', a);
    n.put('B', b);

    for (size_t i = 0; i < 20; i++) {
        std::cout << ' ' << n.front('A');
        n.popFront('A');
    }
    std::cout << '\n';
}

void group3() {
    Wheel a({ '1', 'D', 'D' });
    Wheel d({ '6', '7', '8' });

    NamedWheel n;
    n.put('A', a);
    n.put('D', d);

    for (size_t i = 0; i < 20; i++) {
        std::cout << ' ' << n.front('A');
        n.popFront('A');
    }
    std::cout << '\n';
}

void group4() {
    Wheel a({ '1', 'B', 'C' });
    Wheel b({ '3', '4' });
    Wheel c({ '5', 'B' });

    NamedWheel n;
    n.put('A', a);
    n.put('B', b);
    n.put('C', c);

    for (size_t i = 0; i < 20; i++) {
        std::cout << ' ' << n.front('A');
        n.popFront('A');
    }
    std::cout << '\n';
}

int main() {
    group1();
    group2();
    group3();
    group4();

    return 0;
}
