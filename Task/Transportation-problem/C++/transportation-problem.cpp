#include <algorithm>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <numeric>
#include <string>
#include <vector>
#include <cfloat>

using namespace std;

class Shipment {
public:
    double costPerUnit;
    int r, c;
    double quantity;

    Shipment() : quantity(0), costPerUnit(0), r(-1), c(-1) {
        // empty
    }

    Shipment(double q, double cpu, int r, int c) : quantity(q), costPerUnit(cpu), r(r), c(c) {
        // empty
    }

    friend bool operator==(const Shipment &lhs, const Shipment &rhs) {
        return lhs.costPerUnit == rhs.costPerUnit
            && lhs.quantity == rhs.quantity
            && lhs.r == rhs.r
            && lhs.c == rhs.c;
    }

    friend bool operator!=(const Shipment &lhs, const Shipment &rhs) {
        return !(lhs == rhs);
    }

    static Shipment ZERO;
};
Shipment Shipment::ZERO = {};

vector<int> demand, supply;
vector<vector<double>> costs;
vector<vector<Shipment>> matrix;

void init(string filename) {
    ifstream ifs;

    ifs.open(filename);
    if (!ifs) {
        cerr << "File not found: " << filename << '\n';
        return;
    }

    size_t numSources, numDestinations;
    ifs >> numSources >> numDestinations;

    vector<int> src, dst;
    int t;

    for (size_t i = 0; i < numSources; i++) {
        ifs >> t;
        src.push_back(t);
    }

    for (size_t i = 0; i < numDestinations; i++) {
        ifs >> t;
        dst.push_back(t);
    }

    // fix imbalance
    int totalSrc = accumulate(src.cbegin(), src.cend(), 0);
    int totalDst = accumulate(dst.cbegin(), dst.cend(), 0);
    if (totalSrc > totalDst) {
        dst.push_back(totalSrc - totalDst);
    } else if (totalDst > totalSrc) {
        src.push_back(totalDst - totalSrc);
    }

    supply = src;
    demand = dst;

    costs.clear();
    matrix.clear();

    double d;
    for (size_t i = 0; i < numSources; i++) {
        size_t cap = max(numDestinations, demand.size());

        vector<double> dt(cap);
        vector<Shipment> st(cap);
        for (size_t j = 0; j < numDestinations; j++) {
            ifs >> d;
            dt[j] = d;
        }
        costs.push_back(dt);
        matrix.push_back(st);
    }
    for (size_t i = numSources; i < supply.size(); i++) {
        size_t cap = max(numDestinations, demand.size());

        vector<Shipment> st(cap);
        matrix.push_back(st);

        vector<double> dt(cap);
        costs.push_back(dt);
    }
}

void northWestCornerRule() {
    int northwest = 0;
    for (size_t r = 0; r < supply.size(); r++) {
        for (size_t c = northwest; c < demand.size(); c++) {
            int quantity = min(supply[r], demand[c]);
            if (quantity > 0) {
                matrix[r][c] = Shipment(quantity, costs[r][c], r, c);

                supply[r] -= quantity;
                demand[c] -= quantity;

                if (supply[r] == 0) {
                    northwest = c;
                    break;
                }
            }
        }
    }
}

vector<Shipment> matrixToVector() {
    vector<Shipment> result;
    for (auto &row : matrix) {
        for (auto &s : row) {
            if (s != Shipment::ZERO) {
                result.push_back(s);
            }
        }
    }
    return result;
}

vector<Shipment> getNeighbors(const Shipment &s, const vector<Shipment> &lst) {
    vector<Shipment> nbrs(2);
    for (auto &o : lst) {
        if (o != s) {
            if (o.r == s.r && nbrs[0] == Shipment::ZERO) {
                nbrs[0] = o;
            } else if (o.c == s.c && nbrs[1] == Shipment::ZERO) {
                nbrs[1] = o;
            }
            if (nbrs[0] != Shipment::ZERO && nbrs[1] != Shipment::ZERO) {
                break;
            }
        }
    }
    return nbrs;
}

vector<Shipment> getClosedPath(const Shipment &s) {
    auto path = matrixToVector();
    path.insert(path.begin(), s);

    // remove (and keep removing) elements that do not have a
    // vertical AND horizontal neighbor
    size_t before;
    do {
        before = path.size();
        path.erase(
            remove_if(
                path.begin(), path.end(),
                [&path](Shipment &ship) {
                    auto nbrs = getNeighbors(ship, path);
                    return nbrs[0] == Shipment::ZERO || nbrs[1] == Shipment::ZERO;
                }),
            path.end());
    } while (before != path.size());

    // place the remaining elements in the correct plus-minus order
    vector<Shipment> stones(path.size());
    fill(stones.begin(), stones.end(), Shipment::ZERO);
    auto prev = s;
    for (size_t i = 0; i < stones.size(); i++) {
        stones[i] = prev;
        prev = getNeighbors(prev, path)[i % 2];
    }
    return stones;
}

void fixDegenerateCase() {
    double eps = DBL_MIN;
    if (supply.size() + demand.size() - 1 != matrixToVector().size()) {
        for (size_t r = 0; r < supply.size(); r++) {
            for (size_t c = 0; c < demand.size(); c++) {
                if (matrix[r][c] == Shipment::ZERO) {
                    Shipment dummy(eps, costs[r][c], r, c);
                    if (getClosedPath(dummy).empty()) {
                        matrix[r][c] = dummy;
                        return;
                    }
                }
            }
        }
    }
}

void steppingStone() {
    double maxReduction = 0;
    vector<Shipment> move;
    Shipment leaving;
    bool isNull = true;

    fixDegenerateCase();

    for (size_t r = 0; r < supply.size(); r++) {
        for (size_t c = 0; c < demand.size(); c++) {
            if (matrix[r][c] != Shipment::ZERO) {
                continue;
            }

            Shipment trial(0, costs[r][c], r, c);
            vector<Shipment> path = getClosedPath(trial);

            double reduction = 0;
            double lowestQuantity = INT32_MAX;
            Shipment leavingCandidate;

            bool plus = true;
            for (auto &s : path) {
                if (plus) {
                    reduction += s.costPerUnit;
                } else {
                    reduction -= s.costPerUnit;
                    if (s.quantity < lowestQuantity) {
                        leavingCandidate = s;
                        lowestQuantity = s.quantity;
                    }
                }
                plus = !plus;
            }
            if (reduction < maxReduction) {
                isNull = false;
                move = path;
                leaving = leavingCandidate;
                maxReduction = reduction;
            }
        }
    }

    if (!isNull) {
        double q = leaving.quantity;
        bool plus = true;
        for (auto &s : move) {
            s.quantity += plus ? q : -q;
            matrix[s.r][s.c] = s.quantity == 0 ? Shipment::ZERO : s;
            plus = !plus;
        }
        steppingStone();
    }
}

void printResult(string filename) {
    ifstream ifs;
    string buffer;

    ifs.open(filename);
    if (!ifs) {
        cerr << "File not found: " << filename << '\n';
        return;
    }

    cout << filename << "\n\n";
    while (!ifs.eof()) {
        getline(ifs, buffer);
        cout << buffer << '\n';
    }
    cout << '\n';

    cout << "Optimal solution " << filename << "\n\n";
    double totalCosts = 0.0;
    for (size_t r = 0; r < supply.size(); r++) {
        for (size_t c = 0; c < demand.size(); c++) {
            auto s = matrix[r][c];
            if (s != Shipment::ZERO && s.r == r && s.c == c) {
                cout << ' ' << setw(3) << s.quantity << ' ';
                totalCosts += s.quantity * s.costPerUnit;
            } else {
                cout << "  -  ";
            }
        }
        cout << '\n';
    }
    cout << "\nTotal costs: " << totalCosts << "\n\n";
}

void process(string filename) {
    init(filename);
    northWestCornerRule();
    steppingStone();
    printResult(filename);
}

int main() {
    process("input1.txt");
    process("input2.txt");
    process("input3.txt");

    return 0;
}
