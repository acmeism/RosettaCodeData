#include <cmath>
#include <iomanip>
#include <iostream>
#include <numbers>

class Vector {
public:
	Vector(const double& x, const double& y, const double& z) : x(x), y(y), z(z) {}

	Vector unit_vector() const {
		return scalar_multiply(1.0 / std::sqrt(dot_product(*this)));
	}

	Vector add(const Vector& other) const {
		return Vector(x + other.x, y + other.y, z + other.z);
	}

	Vector scalar_multiply(const double& value) const {
		return Vector(x * value, y * value, z * value);
	}

	double dot_product(const Vector& other) const {
		return x * other.x + y * other.y + z * other.z;
	}

	Vector cross_product(const Vector& other) const {
		return Vector(y * other.z - z * other.y,
					  z * other.x - x * other.z,
					  x * other.y - y * other.x);
	}

	Vector rodrigues_rotation(const Vector& vector, const double& angle) const {
		Vector axis = unit_vector();
		return vector.scalar_multiply(std::cos(angle))
			.add(axis.cross_product(vector).scalar_multiply(std::sin(angle)))
			.add(axis.scalar_multiply(axis.dot_product(vector) * ( 1.0 - std::cos(angle) )));
	}

	void display() const {
		std::cout << std::fixed << std::setprecision(4) << "(" << x << ", " << y << ", " << z << ")";
	}

private:
	const double x, y, z;
};

int main() {
	Vector axis(-1.0, 2.0, 1.0);
	Vector vector(2.5, -1.5, 3.0);

	std::cout << " Angle         Rotated vector" << std::endl;
	std::cout << "-----------------------------------" << std::endl;
	for ( double theta = 0.0; theta <= 2 * std::numbers::pi; theta += std::numbers::pi / 5.0 ) {
		Vector result = axis.rodrigues_rotation(vector, theta);
		std::cout << std::fixed << std::setprecision(4) << theta << "    ";
		result.display(); std::cout << std::endl;
	}
}
