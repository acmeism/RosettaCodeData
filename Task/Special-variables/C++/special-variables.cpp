#include <iostream>

struct SpecialVariables
{
    int i = 0;

    SpecialVariables& operator++()
    {
        // 'this' is a special variable that is a pointer to the current
        // class instance.  It can optionally be used to refer to elements
        // of the class.
        this->i++;  // has the same meaning as 'i++'

        // returning *this lets the object return a reference to itself
        return *this;
    }

};

int main()
{
    SpecialVariables sv;
    auto sv2 = ++sv;     // makes a copy of sv after it was incremented
    std::cout << " sv :" << sv.i << "\n sv2:" << sv2.i << "\n";
}
