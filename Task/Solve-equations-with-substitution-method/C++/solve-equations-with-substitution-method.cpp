#include <iomanip>
#include <iostream>
#include <vector>

int main() {
	const std::vector<double> eqn1 = { 3.0, 1.0, -1.0 };   // 3x + y = -1
	const std::vector<double> eqn2 = { 2.0, -3.0, -19.0 }; // 2x - 3y = -19

	const double y = ( ( eqn1[0] * eqn2[2] ) - ( eqn2[0] * eqn1[2] ) )
		/ ( ( eqn2[0] * -eqn1[1] ) + ( eqn1[0] * eqn2[1] ) );
	const double x = ( eqn1[2] - ( eqn1[1] * y ) ) / eqn1[0];

	std::cout << "x = " << std::setprecision(3) << x << ", y = " << y << std::endl;
}
