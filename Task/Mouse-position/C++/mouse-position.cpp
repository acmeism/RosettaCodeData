#include <iostream>

#include <windows.h>

int main() {
	POINT MousePoint;
	if ( GetCursorPos(&MousePoint) ) {
		std::cout << MousePoint.x << ", " << MousePoint.y << std::endl;
	}
}
