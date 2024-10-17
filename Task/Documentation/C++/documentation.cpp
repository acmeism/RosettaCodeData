/*
 * Program Title: Rosetta Code, Documentation
 * Author       : John Doe
 * Version      : 0.1
 * Date         : 2023/12/31
 * Copyright    : Public domain
 * Description  : An example of C++ program documentation
*/
#include <iostream>
#include <numbers>

/*
 * Calculates the area of a circle with the given radius
 */
double area_circle(const double& radius) {
	return (std::numbers::pi * radius * radius);
}

// Controls the program
int main() {
	// Obtain the users input
	double radius;
	std::cout << "Enter the radius of a circle in centimetres: ";
	std::cin >> radius;

	// Display the result
	std::cout << "The area of the circle is " << area_circle(radius) << " cm\u00b2" << "\n";
}
