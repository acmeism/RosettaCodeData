#include <iomanip>
#include <iostream>
#include <vector>

class Node {
private:
    double v;
    int fixed;

public:
    Node() : v(0.0), fixed(0) {
        // empty
    }

    Node(double v, int fixed) : v(v), fixed(fixed) {
        // empty
    }

    double getV() const {
        return v;
    }

    void setV(double nv) {
        v = nv;
    }

    int getFixed() const {
        return fixed;
    }

    void setFixed(int nf) {
        fixed = nf;
    }
};

void setBoundary(std::vector<std::vector<Node>>& m) {
    m[1][1].setV(1.0);
    m[1][1].setFixed(1);

    m[6][7].setV(-1.0);
    m[6][7].setFixed(-1);
}

double calculateDifference(const std::vector<std::vector<Node>>& m, std::vector<std::vector<Node>>& d, const int w, const int h) {
    double total = 0.0;
    for (int i = 0; i < h; ++i) {
        for (int j = 0; j < w; ++j) {
            double v = 0.0;
            int n = 0;
            if (i > 0) {
                v += m[i - 1][j].getV();
                n++;
            }
            if (j > 0) {
                v += m[i][j - 1].getV();
                n++;
            }
            if (i + 1 < h) {
                v += m[i + 1][j].getV();
                n++;
            }
            if (j + 1 < w) {
                v += m[i][j + 1].getV();
                n++;
            }
            v = m[i][j].getV() - v / n;
            d[i][j].setV(v);
            if (m[i][j].getFixed() == 0) {
                total += v * v;
            }
        }
    }
    return total;
}

double iter(std::vector<std::vector<Node>>& m, const int w, const int h) {
    using namespace std;
    vector<vector<Node>> d;
    for (int i = 0; i < h; ++i) {
        vector<Node> t(w);
        d.push_back(t);
    }

    double curr[] = { 0.0, 0.0, 0.0 };
    double diff = 1e10;

    while (diff > 1e-24) {
        setBoundary(m);
        diff = calculateDifference(m, d, w, h);
        for (int i = 0; i < h; ++i) {
            for (int j = 0; j < w; ++j) {
                m[i][j].setV(m[i][j].getV() - d[i][j].getV());
            }
        }
    }

    for (int i = 0; i < h; ++i) {
        for (int j = 0; j < w; ++j) {
            int k = 0;
            if (i != 0) ++k;
            if (j != 0) ++k;
            if (i < h - 1) ++k;
            if (j < w - 1) ++k;
            curr[m[i][j].getFixed() + 1] += d[i][j].getV()*k;
        }
    }

    return (curr[2] - curr[0]) / 2.0;
}

const int S = 10;
int main() {
    using namespace std;
    vector<vector<Node>> mesh;

    for (int i = 0; i < S; ++i) {
        vector<Node> t(S);
        mesh.push_back(t);
    }

    double r = 2.0 / iter(mesh, S, S);
    cout << "R = " << setprecision(15) << r << '\n';

    return 0;
}
