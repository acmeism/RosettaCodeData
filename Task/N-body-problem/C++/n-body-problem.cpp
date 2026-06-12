#include <algorithm>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

class Vector {
private:
    double px, py, pz;

public:
    Vector() : px(0.0), py(0.0), pz(0.0) {
        // empty
    }

    Vector(double x, double y, double z) : px(x), py(y), pz(z) {
        // empty
    }

    double mod() const {
        return sqrt(px*px + py * py + pz * pz);
    }

    Vector operator+(const Vector& rhs) const {
        return Vector(px + rhs.px, py + rhs.py, pz + rhs.pz);
    }

    Vector operator-(const Vector& rhs) const {
        return Vector(px - rhs.px, py - rhs.py, pz - rhs.pz);
    }

    Vector operator*(double s) const {
        return Vector(px*s, py*s, pz*s);
    }

    bool operator==(const Vector& rhs) const {
        return px == rhs.px
            && py == rhs.py
            && pz == rhs.pz;
    }

    friend std::istream& operator>>(std::istream&, Vector&);
    friend std::ostream& operator<<(std::ostream&, Vector&);
};

std::istream& operator>>(std::istream& in, Vector& v) {
    return in >> v.px >> v.py >> v.pz;
}

std::ostream& operator<<(std::ostream& out, Vector& v) {
    auto precision = out.precision();
    auto width = out.width();
    out << std::fixed << std::setw(width) << std::setprecision(precision) << v.px << "  ";
    out << std::fixed << std::setw(width) << std::setprecision(precision) << v.py << "  ";
    out << std::fixed << std::setw(width) << std::setprecision(precision) << v.pz;
    return out;
}

const Vector ORIGIN{ 0.0, 0.0, 0.0 };

class NBody {
private:
    double gc;
    int bodies;
    int timeSteps;
    std::vector<double> masses;
    std::vector<Vector> positions;
    std::vector<Vector> velocities;
    std::vector<Vector> accelerations;

    void resolveCollisions() {
        for (int i = 0; i < bodies; ++i) {
            for (int j = i + 1; j < bodies; ++j) {
                if (positions[i] == positions[j]) {
                    std::swap(velocities[i], velocities[j]);
                }
            }
        }
    }

    void computeAccelerations() {
        for (int i = 0; i < bodies; ++i) {
            accelerations[i] = ORIGIN;
            for (int j = 0; j < bodies; ++j) {
                if (i != j) {
                    double temp = gc * masses[j] / pow((positions[i] - positions[j]).mod(), 3);
                    accelerations[i] = accelerations[i] + (positions[j] - positions[i]) * temp;
                }
            }
        }
    }

    void computeVelocities() {
        for (int i = 0; i < bodies; ++i) {
            velocities[i] = velocities[i] + accelerations[i];
        }
    }

    void computePositions() {
        for (int i = 0; i < bodies; ++i) {
            positions[i] = positions[i] + velocities[i] + accelerations[i] * 0.5;
        }
    }

public:
    NBody(std::string& fileName) {
        using namespace std;

        ifstream ifs(fileName);
        if (!ifs.is_open()) {
            throw runtime_error("Could not open file.");
        }

        ifs >> gc >> bodies >> timeSteps;

        masses.resize(bodies);
        positions.resize(bodies);
        fill(positions.begin(), positions.end(), ORIGIN);
        velocities.resize(bodies);
        fill(velocities.begin(), velocities.end(), ORIGIN);
        accelerations.resize(bodies);
        fill(accelerations.begin(), accelerations.end(), ORIGIN);

        for (int i = 0; i < bodies; ++i) {
            ifs >> masses[i] >> positions[i] >> velocities[i];
        }

        cout << "Contents of " << fileName << '\n';
        cout << gc << ' ' << bodies << ' ' << timeSteps << '\n';
        for (int i = 0; i < bodies; ++i) {
            cout << masses[i] << '\n';
            cout << positions[i] << '\n';
            cout << velocities[i] << '\n';
        }
        cout << "\nBody   :      x          y          z    |     vx         vy         vz\n";
    }

    int getTimeSteps() {
        return timeSteps;
    }

    void simulate() {
        computeAccelerations();
        computePositions();
        computeVelocities();
        resolveCollisions();
    }

    friend std::ostream& operator<<(std::ostream&, NBody&);
};

std::ostream& operator<<(std::ostream& out, NBody& nb) {
    for (int i = 0; i < nb.bodies; ++i) {
        out << "Body " << i + 1 << " : ";
        out << std::setprecision(6) << std::setw(9) << nb.positions[i];
        out << " | ";
        out << std::setprecision(6) << std::setw(9) << nb.velocities[i];
        out << '\n';
    }
    return out;
}

int main() {
    std::string fileName = "nbody.txt";
    NBody nb(fileName);

    for (int i = 0; i < nb.getTimeSteps(); ++i) {
        std::cout << "\nCycle " << i + 1 << '\n';
        nb.simulate();
        std::cout << nb;
    }

    return 0;
}
