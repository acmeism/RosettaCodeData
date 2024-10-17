#include <cmath>
#include <complex>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numbers>
#include <vector>

std::complex<double> add(const std::complex<double>& c1, const std::complex<double>& c2) {
    return std::complex<double>(c1.real() + c2.real(), c1.imag() + c2.imag());
}

std::complex<double> subtract(const std::complex<double>& c1, const std::complex<double>& c2) {
    return std::complex<double>(c1.real() - c2.real(), c1.imag() - c2.imag());
}

std::complex<double> multiply(const std::complex<double>& c1, const std::complex<double>& c2) {
	return std::complex(c1.real() * c2.real() - c1.imag() * c2.imag(),
			            c1.imag() * c2.real() + c1.real() * c2.imag());
}

std::complex<double> divide(const std::complex<double>& complex, const int32_t& n) {
	return std::complex<double>(complex.real() / n, complex.imag() / n);
}

std::complex<double> divide(const std::complex<double>& c1, const std::complex<double>& c2) {
	const double rr = c1.real() * c2.real() + c1.imag() * c2.imag();
	const double ii = c1.imag() * c2.real() - c1.real() * c2.imag();
	const double norm = c2.real() *c2.real() + c2.imag() * c2.imag();
	return std::complex<double>(rr / norm, ii / norm);
}

struct Return_Value {
	int32_t power_of_two;
	std::vector<std::complex<double>> list;
};

template <typename T>
void print_vector(const std::vector<T>& list) {
	std::cout << "[";
	for ( uint32_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]";
}

template <typename T>
void print_2D_vector(const std::vector<std::vector<T>>& lists) {
	std::cout << "[";
	for ( uint32_t i = 0; i < lists.size() - 1; ++i ) {
		print_vector(lists[i]); std::cout << ", ";
	}
	print_vector(lists.back()); std::cout << "]";
}

template <typename T>
void print_3D_vector(const std::vector<std::vector<std::vector<T>>>& lists) {
	std::cout << "[";
	for ( uint32_t i = 0; i < lists.size() - 1; ++i ) {
		print_2D_vector(lists[i]); std::cout << ", ";
	}
	print_2D_vector(lists.back()); std::cout << "]" << std::endl;
}

Return_Value padAndComplexify(const std::vector<int32_t>& list, const int32_t& power_of_two) {
	const int32_t padded_vector_size = ( power_of_two == 0 ) ?
		1 << static_cast<int32_t>(std::ceil(std::log(list.size()) / std::log(2))) : power_of_two;
	std::vector<std::complex<double>> padded_vector(padded_vector_size, std::complex<double>(0.0, 0.0));
	for ( int32_t i = 0; i < padded_vector_size; ++i ) {
		padded_vector[i] = ( i < static_cast<int32_t>(list.size()) ) ?
			std::complex(static_cast<double>(list[i]), 0.0) : std::complex<double>(0.0, 0.0);
	}
	return Return_Value(padded_vector_size, padded_vector);
}

std::vector<std::vector<int32_t>> pack_2D(const std::vector<int32_t>& to_pack, const uint64_t& to_pack_X,
		                                  const uint64_t& to_pack_Y, const int32_t& convolved_Y) {
	std::vector<std::vector<int32_t>> packed = { to_pack_X, std::vector<int32_t>(to_pack_Y, 0) };
	for ( uint64_t i = 0; i < to_pack_X; ++i ) {
		for ( uint64_t j = 0; j < to_pack_Y; ++j ) {
			packed[i][j] = to_pack[i * convolved_Y + j] / 4;
		}
	}
	return packed;
}

std::vector<std::vector<std::vector<int32_t>>> pack_3D(const std::vector<int32_t>& to_pack,
	const uint64_t& to_pack_X, const uint64_t& to_pack_Y, const uint64_t to_pack_Z,
	const int32_t& convolved_Y, const int32_t& convolved_Z) {

	std::vector<std::vector<std::vector<int32_t>>> packed =
		{ to_pack_X, std::vector<std::vector<int32_t>>(to_pack_Y, std::vector<int32_t>(to_pack_Z, 0)) };
	for ( uint64_t i = 0; i < to_pack_X; ++i ) {
		for ( uint64_t j = 0; j < to_pack_Y; ++j ) {
			for ( uint64_t k = 0; k < to_pack_Z; ++k ) {
				packed[i][j][k] = to_pack[( i * convolved_Y + j ) * convolved_Z + k] / 4;
			}
		}
	}
	return packed;
}

std::vector<int32_t> unpack_2D(const std::vector<std::vector<int32_t>>& to_unpack,
							   const int32_t& convolved_Y) {

	std::vector<int32_t> unpacked(to_unpack.size() * convolved_Y, 0);
	for ( uint32_t i = 0; i < to_unpack.size(); ++i ) {
		for ( uint32_t j = 0; j < to_unpack[0].size(); ++j ) {
			unpacked[i * convolved_Y + j] = to_unpack[i][j];
		}
	}
	return unpacked;
}

std::vector<int32_t> unpack_3D(const std::vector<std::vector<std::vector<int32_t>>>& to_unpack,
		                       const int32_t& convolved_Y, const int32_t& convolved_Z) {

	    std::vector<int32_t> unpacked(to_unpack.size() * convolved_Y * convolved_Z, 0);
	    for ( uint64_t i = 0; i < to_unpack.size(); ++i ) {
	        for ( uint64_t j = 0; j < to_unpack[0].size(); ++j ) {
	            for ( uint64_t k = 0; k < to_unpack[0][0].size(); ++k ) {
	                unpacked[( i * convolved_Y + j ) * convolved_Z + k] = to_unpack[i][j][k];
	            }
	        }
	    }
	    return unpacked;
	}

void fft(std::vector<std::complex<double>>& deconvolution1D, std::vector<std::complex<double>>& result,
					 const int32_t& power_of_two, const int32_t& step, const int32_t& start) {

	if ( step < power_of_two ) {
		fft(result, deconvolution1D, power_of_two, 2 * step, start);
		fft(result, deconvolution1D, power_of_two, 2 * step, start + step);
		for ( int32_t j = 0; j < power_of_two; j += 2 * step ) {
			const double theta = -std::numbers::pi * j / power_of_two;
			std::complex<double> t = multiply(
				std::complex<double>(std::cos(theta), std::sin(theta)), result[j + step + start]);
			deconvolution1D[( j / 2 ) + start]                    = add(result[j + start], t);
			deconvolution1D[( ( j + power_of_two ) / 2 ) + start] = subtract(result[j + start], t);
		}
	}
}

std::vector<std::complex<double>> fft(std::vector<std::complex<double>>& deconvolution1D,
									  const int32_t& powerOfTwo) {

	std::vector<std::complex<double>> result(deconvolution1D);
	fft(deconvolution1D, result, powerOfTwo, 1, 0);
	return result;
}

std::vector<int32_t> deconvolution(const std::vector<int32_t>& convolved, const int32_t& convolved_size,
								   const std::vector<int32_t>& remove, const int32_t& remove_size,
								   const int32_t& convolved_row_size, const int32_t& remain_size) {

	int32_t power_of_two = 0;
	Return_Value convoluted_result = padAndComplexify(convolved, power_of_two);
	std::vector<std::complex<double>> convoluted_padded = convoluted_result.list;
	Return_Value remove_result = padAndComplexify(remove, convoluted_result.power_of_two);
	std::vector<std::complex<double>> remove_padded = remove_result.list;
	power_of_two = remove_result.power_of_two;

	fft(convoluted_padded, power_of_two);
	fft(remove_padded, power_of_two);
	std::vector<std::complex<double>> quotient(power_of_two, std::complex<double>(0.0, 0.0));
	for ( int32_t i = 0; i < power_of_two; ++i ) {
		quotient[i] = divide(convoluted_padded[i], remove_padded[i]);
	}

	fft(quotient, power_of_two);
	for ( int32_t i = 0; i < power_of_two; ++i ) {
		if ( std::abs(quotient[i].real()) < 0.000'000'000'1 ) {
			quotient[i] = std::complex<double>(0.0, 0.0);
		}
	}

	std::vector<int32_t> remain_vector(remain_size, 0);
	int32_t i = 0;
	while ( i > remove_size - convolved_size - convolved_row_size ) {
		remain_vector[-i] = std::lround(
			divide(quotient[( i + power_of_two ) % power_of_two], 32.0).real());
		i -= 1;
	}
	return remain_vector;
}

std::vector<int32_t> deconvolution_1D(const std::vector<int32_t>& convolved,
									  const std::vector<int32_t>& remove) {

	return deconvolution(convolved, convolved.size(), remove, remove.size(),
						 1 , convolved.size() - remove.size() + 1);
}

std::vector<std::vector<int32_t>> deconvolution_2D(const std::vector<std::vector<int32_t>>& convolved,
		                                          const std::vector<std::vector<int32_t>>& toRemove) {

	std::vector<int32_t> convolved_1D = unpack_2D(convolved, convolved[0].size());
	std::vector<int32_t> toRemove_1D = unpack_2D(toRemove, convolved[0].size());
	std::vector<int32_t> toRemain_1D = deconvolution(convolved_1D, convolved.size() * convolved[0].size(),
										             toRemove_1D, toRemove.size() * convolved[0].size(),
		convolved[0].size(), ( convolved[0].size() - toRemove[0].size() + 1 ) * convolved[0].size());

	return pack_2D(toRemain_1D, convolved.size() - toRemove.size() + 1,
				   convolved[0].size() - toRemove[0].size() + 1, convolved[0].size());
}

std::vector<std::vector<std::vector<int32_t>>> deconvolution_3D(
		const std::vector<std::vector<std::vector<int32_t>>>& convolved,
		const std::vector<std::vector<std::vector<int32_t>>>& toRemove) {

	const int32_t cX = convolved.size();
	const int32_t cY = convolved[0].size();
	const int32_t cZ = convolved[0][0].size();

	const int32_t rX = toRemove.size();
	const int32_t rY = toRemove[0].size();
	const int32_t rZ = toRemove[0][0].size();

	const std::vector<int32_t> convolved_1D = unpack_3D(convolved, cY, cZ);
	const std::vector<int32_t> toRemove_1D = unpack_3D(toRemove, cY, cZ);
	const std::vector<int32_t> toRemain_1D = deconvolution(convolved_1D, cX * cY * cZ,
		toRemove_1D, rX * cY * cZ, cY * cZ, ( cX - rX + 1 ) * cY * cZ);

	return pack_3D(toRemain_1D, cX - rX + 1, cY - rY + 1, cZ - rZ + 1, cY, cZ);
}

int main() {
	const std::vector<int32_t> f1 = { -3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1 };

	const std::vector<int32_t> g1 =
		{ 24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7 };

	const std::vector<int32_t> h1 = { -8, -9, -3, -1, -6, 7 };

	const std::vector<std::vector<int32_t>> f2 = { { -5,  2, -2, -6, -7 },
						                           {  9,  7, -6,  5, -7 },
						                           {  1, -1,  9,  2, -7 },
						                           {  5,  9, -9,  2, -5 },
						                           { -8,  5, -2,  8,  5 } };

	const std::vector<std::vector<int32_t>> g2 =
		{ {   40,  -21,   53,   42,  105,    1,   87,   60,   39,   -28 },
	      {  -92,  -64,   19, -167,  -71,  -47,  128, -109,   40,   -21 },
		  {   58,   85,  -93,   37,  101,  -14,    5,   37,  -76,   -56 },
		  {  -90, -135,   60, -125,   68,   53,  223,    4,  -36,   -48 },
		  {   78,   16,    7, -199,  156, -162,   29,   28, -103,   -10 },
		  {  -62,  -89,   69,  -61,   66,  193,  -61,   71,   -8,   -30 },
		  {   48,   -6,   21,   -9, -150,  -22,  -56,   32,   85,    25 } };

	const std::vector<std::vector<int32_t>> h2 = { { -8,  1, -7, -2, -9,  4 },
						                           {  4,  5, -5,  2,  7, -1 },
						                           { -6, -3, -3, -6,  9,  5 } };

	const std::vector<std::vector<std::vector<int32_t>>> f3 = { { { -9,  5, -8 }, {  3,  5,  1 } },
			                                                    { { -1, -7,  2 }, { -5, -6,  6 } },
			                                                    { {  8,  5,  8 }, { -2, -6, -4 } } };

	const std::vector<std::vector<std::vector<int32_t>>> g3 =
		{ { {   54,   42,   53,  -42,   85,  -72 },
		    {   45, -170,   94,  -36,   48,   73 },
		    {  -39,   65, -112,  -16,  -78,  -72 },
		    {    6,  -11,   -6,   62,   49,    8 } },
		  { {  -57,   49,  -23,   52, -135,   66 },
		    {  -23,  127,  -58,   -5, -118,   64 },
		    {   87,  -16,  121,   23,  -41,  -12 },
		    {  -19,   29,   35, -148,  -11,   45 } },
		  { {  -55, -147, -146,  -31,   55,   60 },
		    {  -88,  -45,  -28,   46,  -26, -144 },
		    {  -12, -107,  -34,  150,  249,   66 },
		    {   11,  -15,  -34,   27,  -78,  -50 } },
		  { {   56,   67,  108,    4,    2,  -48 },
		    {   58,   67,   89,   32,   32,   -8 },
		    {  -42,  -31, -103,  -30,  -23,   -8 },
		    {    6,    4,  -26,  -10,   26,   12 } } };

	const std::vector<std::vector<std::vector<int32_t>>> h3 = { { { -6, -8, -5,  9 },
			                                                      { -7,  9, -6, -8 },
			                                                      {  2, -7,  9,  8 } },
			                                                    { {  7,  4,  4, -6 },
			                                                      {  9,  9,  4, -4 },
			                                                      { -3,  7, -2, -3 } } };

	const std::vector<int32_t> H1 = deconvolution_1D(g1, f1);
	std::cout << "deconvolution1D(g1, f1) = "; print_vector(H1); std::cout << std::endl;
	std::cout << "H1 = h1 ? " << std::boolalpha << ( H1 == h1 ) << std::endl << std::endl;

	const std::vector<int32_t> F1 = deconvolution_1D(g1, h1);
	std::cout << "deconvolution1D(g1, h1) = "; print_vector(F1); std::cout << std::endl;
	std::cout << "F1 = f1 ? " << ( F1 == f1 ) << std::endl << std::endl;

	const std::vector<std::vector<int32_t>> H2 = deconvolution_2D(g2, f2);
	std::cout << "deconvolution2D(g2, f2) = "; print_2D_vector(H2); std::cout << std::endl;
	std::cout << "H2 = h2 ? " << ( H2 == h2 ) << std::endl << std::endl;

	const std::vector<std::vector<int32_t>> F2 = deconvolution_2D(g2, h2);
	std::cout << "deconvolution2D(g2, h2) = "; print_2D_vector(F2); std::cout << std::endl;
	std::cout << "F2 = f2 ? " << ( F2 == f2 ) << std::endl << std::endl;

	const std::vector<std::vector<std::vector<int32_t>>> H3 = deconvolution_3D(g3, f3);
	std::cout << "deconvolution3D(g3, f3) = "; print_3D_vector(H3);
	std::cout << "H3 = h3 ? " << ( H3 == h3 ) << std::endl << std::endl;

	const std::vector<std::vector<std::vector<int32_t>>> F3 = deconvolution_3D(g3, h3);
	std::cout << "deconvolution3D(g3, h3) = "; print_3D_vector(F3);
	std::cout << "F3 = f3 ? " << ( F3 == f3 ) << std::endl;
}
