#include <iostream>
#include <sstream>

class Vector3D {
public:
	Vector3D(double x, double y, double z) {
		this->x = x;
		this->y = y;
		this->z = z;
	}

	double dot(const Vector3D& rhs) const {
		return x * rhs.x + y * rhs.y + z * rhs.z;
	}

	Vector3D operator-(const Vector3D& rhs) const {
		return Vector3D(x - rhs.x, y - rhs.y, z - rhs.z);
	}

	Vector3D operator*(double rhs) const {
		return Vector3D(rhs*x, rhs*y, rhs*z);
	}

	friend std::ostream& operator<<(std::ostream&, const Vector3D&);

private:
	double x, y, z;
};

std::ostream & operator<<(std::ostream & os, const Vector3D &f) {
	std::stringstream ss;
	ss << "(" << f.x << ", " << f.y << ", " << f.z << ")";
	return os << ss.str();
}

Vector3D intersectPoint(Vector3D rayVector, Vector3D rayPoint, Vector3D planeNormal, Vector3D planePoint) {
	Vector3D diff = rayPoint - planePoint;
	double prod1 = diff.dot(planeNormal);
	double prod2 = rayVector.dot(planeNormal);
	double prod3 = prod1 / prod2;
	return rayPoint - rayVector * prod3;
}

int main() {
	Vector3D rv = Vector3D(0.0, -1.0, -1.0);
	Vector3D rp = Vector3D(0.0, 0.0, 10.0);
	Vector3D pn = Vector3D(0.0, 0.0, 1.0);
	Vector3D pp = Vector3D(0.0, 0.0, 5.0);
	Vector3D ip = intersectPoint(rv, rp, pn, pp);

	std::cout << "The ray intersects the plane at " << ip << std::endl;

	return 0;
}
