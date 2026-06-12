#include <iostream>
#include <vector>

class Outer
{
    int m_privateField;

public:
    // constructor for Outer class
    Outer(int value) : m_privateField{value}{}

    // define a nested class
    class Inner
    {
        int m_innerValue;

    public:
        // constructor for Inner class
        Inner(int innerValue) : m_innerValue{innerValue}{}

        // adds the values from the outer and inner class objects
        int AddOuter(Outer outer) const
        {
            // a nested class has access to the private members of the outer class
            return outer.m_privateField + m_innerValue;
        }
    };
};

int main()
{
    // a nested class can be constructed like any other class; it does not
    // need an instance of the outer class
    Outer::Inner inner{42};

    // create an outer class and pass it to the inner class
    Outer outer{1};
    auto sum = inner.AddOuter(outer);
    std::cout << "sum: " << sum << "\n";

    // a common usage of nested types is for containers to define their iterators
    std::vector<int> vec{1,2,3};
    std::vector<int>::iterator itr = vec.begin();
    std::cout << "vec[0] = " << *itr << "\n";
}
