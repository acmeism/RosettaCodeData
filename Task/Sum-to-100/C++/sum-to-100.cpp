/*
 * RossetaCode: Sum to 100, C++, STL, OOP.
 * Works with: MSC 16.0 (MSVS2010); GCC 5.1 (use -std=c++11 or -std=c++14 etc.).
 *
 * Find solutions to the "sum to one hundred" puzzle.
 */
#include <iostream>
#include <iomanip>
#include <algorithm>
#include <string>
#include <set>
#include <map>

using namespace std;

class Expression{
    private:
        enum { NUMBER_OF_DIGITS = 9 }; // hack for C++98, use const int in C++11
        enum Op { ADD, SUB, JOIN };
        int code[NUMBER_OF_DIGITS];
    public:
        static const int NUMBER_OF_EXPRESSIONS;
        Expression(){
            for ( int i = 0; i < NUMBER_OF_DIGITS; i++ )
                code[i] = ADD;
        }
        Expression& operator++(int){ // post incrementation
            for ( int i = 0; i < NUMBER_OF_DIGITS; i++ )
                if ( ++code[i] > JOIN ) code[i] = ADD;
                else break;
            return *this;
        }
        operator int() const{
            int value = 0, number = 0, sign = (+1);
            for ( int digit = 1; digit <= 9; digit++ )
                switch ( code[NUMBER_OF_DIGITS - digit] ){
                case ADD: value += sign*number; number = digit; sign = (+1); break;
                case SUB: value += sign*number; number = digit; sign = (-1); break;
                case JOIN:                      number = 10*number + digit;  break;
            }
            return value + sign*number;
        }
        operator string() const{
            string s;
            for ( int digit = 1; digit <= NUMBER_OF_DIGITS; digit++ ){
                switch( code[NUMBER_OF_DIGITS - digit] ){
                    case ADD: if ( digit > 1 ) s.push_back('+'); break;
                    case SUB:                  s.push_back('-'); break;
                }
                s.push_back('0' + digit);
            }
            return s;
        }
};
const int Expression::NUMBER_OF_EXPRESSIONS = 2 * 3*3*3*3 * 3*3*3*3;

ostream& operator<< (ostream& os, Expression& ex){
    ios::fmtflags oldFlags(os.flags());
    os << setw(9) << right << static_cast<int>(ex)    << " = "
       << setw(0) << left  << static_cast<string>(ex) << endl;
    os.flags(oldFlags);
    return os;
}

struct Stat{
    map<int,int> countSum;
    map<int, set<int> > sumCount;
    Stat(){
        Expression expression;
        for ( int i = 0; i < Expression::NUMBER_OF_EXPRESSIONS; i++, expression++ )
            countSum[expression]++;
        for ( auto it = countSum.begin(); it != countSum.end(); it++ )
            sumCount[it->second].insert(it->first);
    }
};

void print(int givenSum){
    Expression expression;
    for ( int i = 0; i < Expression::NUMBER_OF_EXPRESSIONS; i++, expression++ )
        if ( expression == givenSum )
            cout << expression;
}

void comment(string commentString){
    cout << endl << commentString << endl << endl;
}

int main(){
    Stat stat;

    comment( "Show all solutions that sum to 100" );
    const int givenSum = 100;
    print(givenSum);

    comment( "Show the sum that has the maximum number of solutions" );
    auto maxi = max_element(stat.sumCount.begin(),stat.sumCount.end());
    auto it = maxi->second.begin();
    while ( *it < 0 ) it++;
    cout << static_cast<int>(*it) << " has " << maxi->first << " solutions" << endl;

    comment( "Show the lowest positive number that can't be expressed" );
    int value = 0;
    while(stat.countSum.count(value) != 0) value++;
    cout << value << endl;

    comment( "Show the ten highest numbers that can be expressed" );
    auto rit = stat.countSum.rbegin();
    for ( int i = 0; i < 10; i++, rit++ ) print(rit->first);

    return 0;
}
