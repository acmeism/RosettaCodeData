#include <iostream>

template<unsigned int N> void bottles(){
    std::cout << N << " bottles of beer on the wall\n"
              << N << " bottles of beer\n"
              << "Take one down, pass it around\n"
              << N - 1 << " bottles of beer on the wall\n\n";
    bottles<N-1>();
}

template<> void bottles<0>(){
    std::cout<<"No more bottles of beer on the wall\n"
               "No more bottles of beer\n"
               "Go to the store and buy some more\n"
               "99 bottles of beer on the wall...\n\n";
}

int main(){
    bottles<99>();
}
