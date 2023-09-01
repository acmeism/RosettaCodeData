#include <cstdint>
#include <iostream>
#include <string>

int64_t own_password_calculation(const int64_t& password, const std::string& nonce) {
	const int64_t m1        = 0xFFFF'FFFF;
	const int64_t m8        = 0xFFFF'FFF8;
	const int64_t m16       = 0xFFFF'FFF0;
	const int64_t m128      = 0xFFFF'FF80;
	const int64_t m16777216 = 0xFF00'0000;

	bool flag = true;
	int64_t number1 = 0;
	int64_t number2 = 0;

	for ( char ch : nonce ) {
		number2 = number2 & m1;

		switch (ch) {
			case '1':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = number2 & m128;
				number1 = number1 >> 7;
				number2 = number2 << 25;
				number1 = number1 + number2;
				break;

			case '2':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = number2 & m16;
				number1 = number1 >> 4;
				number2 = number2 << 28;
				number1 = number1 + number2;
				break;

			case '3':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = number2 & m8;
				number1 = number1 >> 3;
				number2 = number2 << 29;
				number1 = number1 + number2;
				break;

			case '4':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = number2 << 1;
				number2 = number2 >> 31;
				number1 = number1 + number2;
				break;

			case '5':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = number2 << 5;
				number2 = number2 >> 27;
				number1 = number1 + number2;
				break;

			case '6':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = number2 << 12;
				number2 = number2 >> 20;
				number1 = number1 + number2;
				break;

			case '7':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = number2 & 0xFF00L;
				number1 = number1 + ( ( number2 & 0xFFL ) << 24 );
				number1 = number1 + ( ( number2 & 0xFF0000L ) >> 16 );
				number2 = ( number2 & m16777216 ) >> 8;
				number1 = number1 + number2;
				break;

			case '8':
				if ( flag ) { number2 = password;}
				flag = false;
				number1 = number2 & 0xFFFFL;
				number1 = number1 << 16;
				number1 = number1 + ( number2 >> 24 );
				number2 = number2 & 0xFF0000L;
				number2 = number2 >> 8;
				number1 = number1 + number2;
				break;

			case '9':
				if ( flag ) { number2 = password; }
				flag = false;
				number1 = ~number2;
				break;

			default:
				number1 = number2;
				break;
		}
		number2 = number1;
	}

	return number1 & m1;
}

void own_password_calculation_test(const std::string& password, const std::string& nonce, const int64_t& expected) {
	const int64_t result = own_password_calculation(std::stoll(password), nonce);
	std::string message = password + "  " + nonce + "  " + std::to_string(result) + "  " + std::to_string(expected);
	std::cout << ( ( result == expected ) ? "PASS  " + message : "FAIL  " + message ) << std::endl;
}

int main() {
	own_password_calculation_test("12345", "603356072", 25280520);
	own_password_calculation_test("12345", "410501656", 119537670);
}
