#include <algorithm>
#include <array>
#include <cassert>
#include <initializer_list>
#include <iostream>

constexpr size_t sp_rows = 3;
constexpr size_t sp_columns = 3;
constexpr size_t sp_cells = sp_rows * sp_columns;
constexpr int sp_limit = 4;

class abelian_sandpile {
    friend std::ostream& operator<<(std::ostream&, const abelian_sandpile&);

public:
    abelian_sandpile();
    explicit abelian_sandpile(std::initializer_list<int> init);
    void stabilize();
    bool is_stable() const;
    void topple();
    abelian_sandpile& operator+=(const abelian_sandpile&);
    bool operator==(const abelian_sandpile&);

private:
    int& cell_value(size_t row, size_t column) {
        return cells_[cell_index(row, column)];
    }
    static size_t cell_index(size_t row, size_t column) {
        return row * sp_columns + column;
    }
    static size_t row_index(size_t cell_index) {
        return cell_index/sp_columns;
    }
    static size_t column_index(size_t cell_index) {
        return cell_index % sp_columns;
    }

    std::array<int, sp_cells> cells_;
};

abelian_sandpile::abelian_sandpile() {
    cells_.fill(0);
}

abelian_sandpile::abelian_sandpile(std::initializer_list<int> init) {
    assert(init.size() == sp_cells);
    std::copy(init.begin(), init.end(), cells_.begin());
}

abelian_sandpile& abelian_sandpile::operator+=(const abelian_sandpile& other) {
    for (size_t i = 0; i < sp_cells; ++i)
        cells_[i] += other.cells_[i];
    stabilize();
    return *this;
}

bool abelian_sandpile::operator==(const abelian_sandpile& other) {
    return cells_ == other.cells_;
}

bool abelian_sandpile::is_stable() const {
    return std::none_of(cells_.begin(), cells_.end(),
                        [](int a) { return a >= sp_limit; });
}

void abelian_sandpile::topple() {
    for (size_t i = 0; i < sp_cells; ++i) {
        if (cells_[i] >= sp_limit) {
            cells_[i] -= sp_limit;
            size_t row = row_index(i);
            size_t column = column_index(i);
            if (row > 0)
                ++cell_value(row - 1, column);
            if (row + 1 < sp_rows)
                ++cell_value(row + 1, column);
            if (column > 0)
                ++cell_value(row, column - 1);
            if (column + 1 < sp_columns)
                ++cell_value(row, column + 1);
            break;
        }
    }
}

void abelian_sandpile::stabilize() {
    while (!is_stable())
        topple();
}

abelian_sandpile operator+(const abelian_sandpile& a, const abelian_sandpile& b) {
    abelian_sandpile c(a);
    c += b;
    return c;
}

std::ostream& operator<<(std::ostream& out, const abelian_sandpile& as) {
    for (size_t i = 0; i < sp_cells; ++i) {
        if (i > 0)
            out << (as.column_index(i) == 0 ? '\n' : ' ');
        out << as.cells_[i];
    }
    return out << '\n';
}

int main() {
    std::cout << std::boolalpha;

    std::cout << "Avalanche:\n";
    abelian_sandpile sp{4,3,3, 3,1,2, 0,2,3};
    while (!sp.is_stable()) {
        std::cout << sp << "stable? " << sp.is_stable() << "\n\n";
        sp.topple();
    }
    std::cout << sp << "stable? " << sp.is_stable() << "\n\n";

    std::cout << "Commutativity:\n";
    abelian_sandpile s1{1,2,0, 2,1,1, 0,1,3};
    abelian_sandpile s2{2,1,3, 1,0,1, 0,1,0};
    abelian_sandpile sum1(s1 + s2);
    abelian_sandpile sum2(s2 + s1);
    std::cout << "s1 + s2 equals s2 + s1? " << (sum1 == sum2) << "\n\n";
    std::cout << "s1 + s2 = \n" << sum1;
    std::cout << "\ns2 + s1 = \n" << sum2;
    std::cout << '\n';

    std::cout << "Identity:\n";
    abelian_sandpile s3{3,3,3, 3,3,3, 3,3,3};
    abelian_sandpile s3_id{2,1,2, 1,0,1, 2,1,2};
    abelian_sandpile sum3(s3 + s3_id);
    abelian_sandpile sum4(s3_id + s3_id);
    std::cout << "s3 + s3_id equals s3? " << (sum3 == s3) << '\n';
    std::cout << "s3_id + s3_id equals s3_id? " << (sum4 == s3_id) << "\n\n";
    std::cout << "s3 + s3_id = \n" << sum3;
    std::cout << "\ns3_id + s3_id = \n" << sum4;

    return 0;
}
