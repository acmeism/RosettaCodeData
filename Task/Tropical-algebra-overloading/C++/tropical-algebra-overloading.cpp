#include <iostream>
#include <optional>

using namespace std;

class TropicalAlgebra
{
    // use an unset std::optional to represent -infinity
    optional<double> m_value;

public:
    friend std::ostream& operator<<(std::ostream&, const TropicalAlgebra&);
    friend TropicalAlgebra pow(const TropicalAlgebra& base, unsigned int exponent) noexcept;

    // create a point that is initialized to -infinity
    TropicalAlgebra() = default;

    // construct with a value
    explicit TropicalAlgebra(double value) noexcept
        : m_value{value} {}

    // add a value to this one ( p+=q ).  it is common to also overload
    // the += operator when overloading +
    TropicalAlgebra& operator+=(const TropicalAlgebra& rhs) noexcept
    {
        if(!m_value)
        {
            // this point is -infinity so the other point is max
            *this = rhs;
        }
        else if (!rhs.m_value)
        {
            // since rhs is -infinity this point is max
        }
        else
        {
            // both values are valid, find the max
            *m_value = max(*rhs.m_value, *m_value);
        }

        return *this;
    }

    // multiply this value by another (p *= q)
    TropicalAlgebra& operator*=(const TropicalAlgebra& rhs) noexcept
    {
        if(!m_value)
        {
            // since this value is -infinity this point does not need to be
            // modified
        }
        else if (!rhs.m_value)
        {
            // the other point is -infinity, make this -infinity too
            *this = rhs;
        }
        else
        {
            *m_value += *rhs.m_value;
        }

        return *this;
    }
};

// add values (p + q)
inline TropicalAlgebra operator+(TropicalAlgebra lhs, const TropicalAlgebra& rhs) noexcept
{
    // implemented using the += operator defined above
    lhs += rhs;
    return lhs;
}

// multiply values (p * q)
inline TropicalAlgebra operator*(TropicalAlgebra lhs, const TropicalAlgebra&  rhs) noexcept
{
    lhs *= rhs;
    return lhs;
}

// pow is the idomatic way for exponentiation in C++
inline TropicalAlgebra pow(const TropicalAlgebra& base, unsigned int exponent) noexcept
{
    auto result = base;
    for(unsigned int i = 1; i < exponent; i++)
    {
        // compute the power by successive multiplication
        result *= base;
    }
    return result;
}

// print the point
ostream& operator<<(ostream& os, const TropicalAlgebra& pt)
{
    if(!pt.m_value) cout << "-Inf\n";
    else cout << *pt.m_value << "\n";
    return os;
}

int main(void) {
    const TropicalAlgebra a(-2);
    const TropicalAlgebra b(-1);
    const TropicalAlgebra c(-0.5);
    const TropicalAlgebra d(-0.001);
    const TropicalAlgebra e(0);
    const TropicalAlgebra h(1.5);
    const TropicalAlgebra i(2);
    const TropicalAlgebra j(5);
    const TropicalAlgebra k(7);
    const TropicalAlgebra l(8);
    const TropicalAlgebra m; // -Inf

    cout << "2 * -2 == " << i * a;
    cout << "-0.001 + -Inf == " << d + m;
    cout << "0 * -Inf == " << e * m;
    cout << "1.5 + -1 == " << h + b;
    cout << "-0.5 * 0 == " << c * e;
    cout << "pow(5, 7) == " << pow(j, 7);
    cout << "5 * (8 + 7)) == " << j * (l + k);
    cout << "5 * 8 + 5 * 7 == " << j * l + j * k;
}
