#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>

using namespace std;

class Grid {
public:
    Grid(const double p, const int x, const int y) : m(x), n(y) {
        const int thresh = static_cast<int>(RAND_MAX * p);

        // Allocate two addition rows to avoid checking bounds.
        // Bottom row is also required by drippage
        start = new cell[m * (n + 2)];
        cells = start + m;
        for (auto i = 0; i < m; i++) start[i] = RBWALL;
        end = cells;
        for (auto i = 0; i < y; i++) {
            for (auto j = x; --j;)
                *end++ = (rand() < thresh ? BWALL : 0) | (rand() < thresh ? RWALL : 0);
            *end++ = RWALL | (rand() < thresh ? BWALL : 0);
        }
        memset(end, 0u, sizeof(cell) * m);
    }

    ~Grid() {
        delete[] start;
        cells = 0;
        start = 0;
        end = 0;
    }

    int percolate() const {
        auto i = 0;
        for (; i < m && !fill(cells + i); i++);
        return i < m;
    }

    void show() const {
        for (auto j = 0; j < m; j++)
            cout << ("+-");
        cout << '+' << endl;

        for (auto i = 0; i <= n; i++) {
            cout << (i == n ? ' ' : '|');
            for (auto j = 0; j < m; j++) {
                cout << ((cells[i * m + j] & FILL) ? "#" : " ");
                cout << ((cells[i * m + j] & RWALL) ? '|' : ' ');
            }
            cout << endl;

            if (i == n) return;

            for (auto j = 0; j < m; j++)
                cout << ((cells[i * m + j] & BWALL) ? "+-" : "+ ");
            cout << '+' << endl;
        }
    }

private:
    enum cell_state {
        FILL   = 1 << 0,
        RWALL  = 1 << 1,       // right wall
        BWALL  = 1 << 2,       // bottom wall
        RBWALL = RWALL | BWALL // right/bottom wall
    };

    typedef unsigned int cell;

    bool fill(cell* p) const {
        if ((*p & FILL)) return false;
        *p |= FILL;
        if (p >= end) return true; // success: reached bottom row

        return (!(p[0] & BWALL) && fill(p + m)) || (!(p[0] & RWALL) && fill(p + 1))
                ||(!(p[-1] & RWALL) && fill(p - 1)) || (!(p[-m] & BWALL) && fill(p - m));
    }

    cell* cells;
    cell* start;
    cell* end;
    const int m;
    const int n;
};

int main() {
    const auto M = 10, N = 10;
    const Grid grid(.5, M, N);
    grid.percolate();
    grid.show();

    const auto C = 10000;
    cout << endl << "running " << M << "x" << N << " grids " << C << " times for each p:" << endl;
    for (auto p = 1; p < M; p++) {
        auto cnt = 0, i = 0;
        for (; i < C; i++)
            cnt += Grid(p / static_cast<double>(M), M, N).percolate();
        cout << "p = " << p / static_cast<double>(M) << ": " << static_cast<double>(cnt) / i << endl;
    }

    return EXIT_SUCCESS;
}
