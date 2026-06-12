#include <algorithm>
#include <functional>
#include <iostream>
#include <random>
#include <vector>

const auto PI = std::atan2(0, -1);

bool double_equals(double a, double b, double epsilon = 0.001) {
    return std::abs(a - b) < epsilon;
}

template <typename T>
bool vector_equals(const std::vector<T> & lhs, const std::vector<T> & rhs) {
    if (lhs.size() != rhs.size()) {
        return false;
    }

    for (size_t i = 0; i < lhs.size(); i++) {
        if (!vector_equals(lhs[i], rhs[i])) {
            return false;
        }
    }

    return true;
}

template <typename T>
bool vector_equals(const T & lhs, const T & rhs) {
    return lhs == rhs;
}

template <>
bool vector_equals(const std::vector<double> & lhs, const std::vector<double> & rhs) {
    if (lhs.size() != rhs.size()) {
        return false;
    }

    for (size_t i = 0; i < lhs.size(); i++) {
        if (!double_equals(lhs[i], rhs[i])) {
            return false;
        }
    }

    return true;
}

template <typename T>
std::ostream& operator<<(std::ostream & os, const std::vector<T> & v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << '[';
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", " << *it;
        it = std::next(it);
    }
    return os << ']';
}

double uniform01() {
    static std::default_random_engine generator;
    static std::uniform_real_distribution<double> distribution(0.0, 1.0);
    return distribution(generator);
}

struct Parameters {
    double omega, phip, phig;

    bool operator==(const Parameters& rhs) {
        return double_equals(omega, rhs.omega)
            && double_equals(phip, rhs.phip)
            && double_equals(phig, rhs.phig);
    }
};

struct State {
    int iter;
    std::vector<double> gbpos;
    double gbval;
    std::vector<double> min;
    std::vector<double> max;
    Parameters parameters;
    std::vector<std::vector<double>> pos;
    std::vector<std::vector<double>> vel;
    std::vector<std::vector<double>> bpos;
    std::vector<double> bval;
    int nParticles;
    int nDims;

    bool operator==(const State& rhs) {
        return iter == rhs.iter
            && vector_equals(gbpos, rhs.gbpos)
            && double_equals(gbval, rhs.gbval)
            && vector_equals(min, rhs.min)
            && vector_equals(max, rhs.max)
            && parameters == rhs.parameters
            && vector_equals(pos, rhs.pos)
            && vector_equals(vel, rhs.vel)
            && vector_equals(bpos, rhs.bpos)
            && vector_equals(bval, rhs.bval)
            && nParticles == rhs.nParticles
            && nDims == rhs.nDims;
    }

    void report(const std::string& testFunc) {
        std::cout << "Test Function        : " << testFunc << '\n';
        std::cout << "Iterations           : " << iter << '\n';
        std::cout << "Global Best Position : " << gbpos << '\n';
        std::cout << "Global Best Value    : " << gbval << '\n';
    }
};

State psoInit(const std::vector<double> & min, const std::vector<double> & max, const Parameters & parameters, int nParticles) {
    int nDims = min.size();

    std::vector<std::vector<double>> pos(nParticles);
    for (int i = 0; i < nParticles; i++) {
        std::copy(min.cbegin(), min.cend(), std::back_inserter(pos[i]));
    }

    std::vector<std::vector<double>> vel(nParticles);
    for (int i = 0; i < nParticles; i++) {
        vel[i].resize(nDims);
    }

    std::vector<std::vector<double>> bpos(nParticles);
    for (int i = 0; i < nParticles; i++) {
        std::copy(min.cbegin(), min.cend(), std::back_inserter(bpos[i]));
    }

    std::vector<double> bval(nParticles, HUGE_VAL);

    auto iter = 0;

    std::vector<double> gbpos(nDims, HUGE_VAL);

    auto gbval = HUGE_VAL;

    return{ iter, gbpos, gbval, min, max, parameters, pos, vel, bpos, bval, nParticles, nDims };
}

State pso(const std::function<double(const std::vector<double>&)> & fn, const State & y) {
    auto p = y.parameters;

    std::vector<double> v(y.nParticles);

    std::vector<std::vector<double>> bpos(y.nParticles);
    for (int i = 0; i < y.nParticles; i++) {
        std::copy(y.min.cbegin(), y.min.cend(), std::back_inserter(bpos[i]));
    }

    std::vector<double> bval(y.nParticles);

    std::vector<double> gbpos(y.nDims);

    auto gbval = HUGE_VAL;

    for (int j = 0; j < y.nParticles; j++) {
        // evaluate
        v[j] = fn(y.pos[j]);
        // update
        if (v[j] < y.bval[j]) {
            bpos[j] = y.pos[j];
            bval[j] = v[j];
        } else {
            bpos[j] = y.bpos[j];
            bval[j] = y.bval[j];
        }
        if (bval[j] < gbval) {
            gbval = bval[j];
            gbpos = bpos[j];
        }
    }

    auto rg = uniform01();

    std::vector<std::vector<double>> pos(y.nParticles);
    for (size_t i = 0; i < pos.size(); i++) {
        pos[i].resize(y.nDims);
    }

    std::vector<std::vector<double>> vel(y.nParticles);
    for (size_t i = 0; i < vel.size(); i++) {
        vel[i].resize(y.nDims);
    }

    for (size_t j = 0; j < y.nParticles; j++) {
        // migrate
        auto rp = uniform01();
        bool ok = true;
        std::fill(vel[j].begin(), vel[j].end(), 0);
        std::fill(pos[j].begin(), pos[j].end(), 0);
        for (int k = 0; k < y.nDims; ++k) {
            vel[j][k] = p.omega * y.vel[j][k] +
                p.phip * rp * (bpos[j][k] - y.pos[j][k]) +
                p.phig * rg * (gbpos[k] - y.pos[j][k]);
            pos[j][k] = y.pos[j][k] + vel[j][k];
            ok = ok && y.min[k] < pos[j][k] && y.max[k] > pos[j][k];
        }
        if (!ok) {
            for (int k = 0; k < y.nDims; ++k) {
                pos[j][k] = y.min[k] + (y.max[k] - y.min[k]) * uniform01();
            }
        }
    }

    auto iter = 1 + y.iter;

    return { iter, gbpos, gbval, y.min, y.max, y.parameters, pos, vel, bpos, bval, y.nParticles, y.nDims };
}

State iterate(const std::function<double(const std::vector<double>&)> & fn, int n, const State & y) {
    State r(y);
    if (n == INT32_MAX) {
        State old(y);
        while (true) {
            r = pso(fn, r);
            if (r == old) {
                break;
            }
            old = r;
        }
    } else {
        for (int i = 0; i < n; i++) {
            r = pso(fn, r);
        }
    }
    return r;
}

double mccormick(const std::vector<double> & x) {
    auto a = x[0];
    auto b = x[1];
    return sin(a + b) + (a - b) * (a - b) + 1.0 + 2.5 * b - 1.5 * a;
}

double michalewicz(const std::vector<double> & x) {
    auto m = 10;
    auto d = x.size();
    auto sum = 0.0;
    for (int i = 1; i < d; ++i) {
        auto j = x[i - 1];
        auto k = sin(i * j * j / PI);
        sum += sin(j) * pow(k, (2.0 * m));
    }
    return -sum;
}

int main() {
    auto state = psoInit(
        { -1.5, -3.0 },
        { 4.0, 4.0 },
        { 0.0, 0.6, 0.3 },
        100
    );
    state = iterate(mccormick, 40, state);
    state.report("McCormick");
    std::cout << "f(-0.54719, -1.54719) : " << mccormick({ -0.54719, -1.54719 }) << '\n';
    std::cout << '\n';

    state = psoInit(
        { 0.0, 0.0 },
        {PI, PI},
        { 0.3, 0.3, 0.3 },
        1000
    );
    state = iterate(michalewicz, 30, state);
    state.report("Michalewicz (2D)");
    std::cout << "f(2.20, 1.57)        : " << michalewicz({ 2.2, 1.57 }) << '\n';
}
