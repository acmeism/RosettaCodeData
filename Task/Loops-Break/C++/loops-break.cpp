#include <iostream>
#include <ctime>
#include <cstdlib>

int main(){
	srand(time(NULL)); // randomize seed
	while(true){
		const int a = rand() % 20; // biased towards lower numbers if RANDMAX % 20 > 0
		std::cout << a << std::endl;
		if(a == 10)
			break;
		const int b = rand() % 20;
		std::cout << b << std::endl;
	}
	return 0;
}
