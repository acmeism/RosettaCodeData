#include <cmath>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

std::vector<int32_t> p(512, 0);

double fade(const double& t) {
	return t * t * t * ( t * ( t * 6 - 15 ) + 10 );
}

double lerp(const double& t, const double& a, const double& b) {
	return a + t * ( b - a );
}

double grad(const int32_t& hash, const double& x, const double& y, const double& z) {
    const int32_t h = hash & 15;                           // CONVERT LOW 4 BITS OF HASH CODE
    const double u = h < 8 ? x : y;                        // INTO 12 GRADIENT DIRECTIONS.
	const double v = h < 4 ? y : ( h == 12 || h == 14 ) ? x : z;
    return ( ( h & 1 ) == 0 ? u : -u ) + ( ( h & 2 ) == 0 ? v : -v );
}

double perlin_noise(double x, double y, double z) {
    int32_t X = static_cast<int32_t>(floor(x)) & 0xff;     // FIND UNIT CUBE THAT
    int32_t Y = static_cast<int32_t>(floor(y)) & 0xff;     // CONTAINS POINT.
    int32_t Z = static_cast<int32_t>(floor(z)) & 0xff;
    x -= floor(x);                                         // FIND RELATIVE X,Y,Z
    y -= floor(y);                                         // OF POINT IN CUBE.
    z -= floor(z);

    const double u = fade(x);                              // COMPUTE FADE CURVES
    const double v = fade(y);                              // FOR EACH OF X,Y,Z.
    const double w = fade(z);

    const int32_t A  = p[X    ] + Y;
    const int32_t AA = p[A    ] + Z;
    const int32_t AB = p[A + 1] + Z;      // HASH COORDINATES OF
    const int32_t B  = p[X + 1] + Y;
    const int32_t BA = p[B    ] + Z;
    const int32_t BB = p[B + 1] + Z;      // THE 8 CUBE CORNERS,

    return lerp(w, lerp(v, lerp(u, grad(p[AA    ], x    , y    , z    ),    // AND ADD
	 							   grad(p[BA    ], x - 1, y    , z    )),   // BLENDED
						   lerp(u, grad(p[AB    ], x    , y - 1, z    ),    // RESULTS
							       grad(p[BB    ], x - 1, y - 1, z    ))),  // FROM  8
				   lerp(v, lerp(u, grad(p[AA + 1], x    , y    , z - 1),    // CORNERS
								   grad(p[BA + 1], x - 1, y    , z - 1)),   // OF CUBE
						   lerp(u, grad(p[AB + 1], x    , y - 1, z - 1),
								   grad(p[BB + 1], x - 1, y - 1, z - 1))));
}

void read_file(const std::string& file_name) {
	std::ifstream file("../" + file_name);
	if ( file.is_open() ) {
		int32_t index = 0;
	    std::string line;
	    while( std::getline(file, line) ) {
	    	std::istringstream stream(line);
	    	std::string word;
	    	while ( std::getline(stream, word, ',') ) {
	    		const int32_t number = std::stoi(word);
	    		p[index] = number;
	    		p[256 + index] = number;
	    		index++;
	    	}
	    }
	} else {
		std::cout << "Cannot open file" << std::endl;
	}
}

int main() {
	read_file("permutation.txt");

	std::cout << "Perlin noise applied to (3.14, 42.0, 7.0) gives " << std::setprecision(16)
			  <<perlin_noise(3.14, 42.0, 7.0) << std::endl;
}
