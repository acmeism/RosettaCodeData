#include <iostream>
#include <ppl.h> // MSVC++

void a(void) { std::cout << "Eat\n";   }
void b(void) { std::cout << "At\n";    }
void c(void) { std::cout << "Joe's\n"; }

int main()
{
    // function pointers
    Concurrency::parallel_invoke(&a, &b, &c);

    // C++11 lambda functions
    Concurrency::parallel_invoke(
        []{ std::cout << "Enjoy\n";   },
        []{ std::cout << "Rosetta\n"; },
        []{ std::cout << "Code\n";    }
    );
    return 0;
}
