#include <iostream>
#include <cmath>
#include <optional>
#include <vector>

using namespace std;

// std::optional can be a maybe monad.  Use the >> operator as the bind function
template <typename T>
auto operator>>(const optional<T>& monad, auto f)
{
    if(!monad.has_value())
    {
        // Return an empty maybe monad of the same type as if there
        // was a value
        return optional<remove_reference_t<decltype(*f(*monad))>>();
    }

    return f(*monad);
}

// The Pure function returns a maybe monad containing the value t
auto Pure(auto t)
{
    return optional{t};
}

// A safe function to invert a value
auto SafeInverse(double v)
{
    if (v == 0)
    {
        return optional<decltype(v)>();
    }
    else
    {
        return optional(1/v);
    }
}

// A safe function to calculate the arc cosine
auto SafeAcos(double v)
{
    if(v < -1 || v > 1)
    {
        // The input is out of range, return an empty monad
        return optional<decltype(acos(v))>();
    }
    else
    {
        return optional(acos(v));
    }
}

// Print the monad
template<typename T>
ostream& operator<<(ostream& s, optional<T> v)
{
    s << (v ? to_string(*v) : "nothing");
    return s;
}

int main()
{
    // Use bind to compose SafeInverse and SafeAcos
    vector<double> tests {-2.5, -1, -0.5, 0, 0.5, 1, 2.5};

    cout << "x -> acos(1/x) , 1/(acos(x)\n";
    for(auto v : tests)
    {
        auto maybeMonad = Pure(v);
        auto inverseAcos = maybeMonad >> SafeInverse >> SafeAcos;
        auto acosInverse = maybeMonad >> SafeAcos >> SafeInverse;
        cout << v << " -> " << inverseAcos << ", " << acosInverse << "\n";
    }
}
