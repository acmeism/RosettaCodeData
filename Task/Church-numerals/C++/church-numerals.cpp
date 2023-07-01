#include <iostream>

// apply the function zero times (return an identity function)
auto Zero = [](auto){ return [](auto x){ return x; }; };

// define Church True and False
auto True = [](auto a){ return [=](auto){ return a; }; };
auto False = [](auto){ return [](auto b){ return b; }; };

// apply the function f one more time
auto Successor(auto a) {
    return [=](auto f) {
        return [=](auto x) {
            return a(f)(f(x));
        };
    };
}

// apply the function a times after b times
auto Add(auto a, auto b) {
    return [=](auto f) {
        return [=](auto x) {
            return a(f)(b(f)(x));
        };
    };
}

// apply the function a times b times
auto Multiply(auto a, auto b) {
    return [=](auto f) {
        return a(b(f));
    };
}

// apply the function a^b times
auto Exp(auto a, auto b) {
    return b(a);
}

// check if a number is zero
auto IsZero(auto a){
    return a([](auto){ return False; })(True);
}

// apply the function f one less time
auto Predecessor(auto a) {
    return [=](auto f) {
        return [=](auto x) {
            return a(
                [=](auto g) {
                    return [=](auto h){
                        return h(g(f));
                    };
                }
             )([=](auto){ return x; })([](auto y){ return y; });
        };
    };
}

// apply the Predecessor function b times to a
auto Subtract(auto a, auto b) {
    {
        return b([](auto c){ return Predecessor(c); })(a);
    };
}

namespace
{
    // helper functions for division.

    // end the recusrion
    auto Divr(decltype(Zero), auto) {
        return Zero;
    }

    // count how many times b can be subtracted from a
    auto Divr(auto a, auto b) {
        auto a_minus_b = Subtract(a, b);
        auto isZero = IsZero(a_minus_b);

        // normalize all Church zeros to be the same (intensional equality).
        // In this implemetation, Church numerals have extensional equality
        // but not intensional equality.  '6 - 3' and '4 - 1' have extensional
        // equality because they will both cause a function to be called
        // three times but due to the static type system they do not have
        // intensional equality.  Internally the two numerals are represented
        // by different lambdas.  Normalize all Church zeros (1 - 1, 2 - 2, etc.)
        // to the same zero (Zero) so it will match the function that end the
        // recursion.
        return isZero
                    (Zero)
                    (Successor(Divr(isZero(Zero)(a_minus_b), b)));
    }
}

// apply the function a / b times
auto Divide(auto a, auto b) {
    return Divr(Successor(a), b);
}

// create a Church numeral from an integer at compile time
template <int N> constexpr auto ToChurch() {
    if constexpr(N<=0) return Zero;
    else return Successor(ToChurch<N-1>());
}

// use an increment function to convert the Church number to an integer
int ToInt(auto church) {
    return church([](int n){ return n + 1; })(0);
}

int main() {
    // show some examples
    auto three = Successor(Successor(Successor(Zero)));
    auto four = Successor(three);
    auto six = ToChurch<6>();
    auto ten = ToChurch<10>();
    auto thousand = Exp(ten, three);

    std::cout << "\n 3 + 4 = " << ToInt(Add(three, four));
    std::cout << "\n 3 * 4 = " << ToInt(Multiply(three, four));
    std::cout << "\n 3^4 = " << ToInt(Exp(three, four));
    std::cout << "\n 4^3 = " << ToInt(Exp(four, three));
    std::cout << "\n 0^0 = " << ToInt(Exp(Zero, Zero));
    std::cout << "\n 4 - 3 = " << ToInt(Subtract(four, three));
    std::cout << "\n 3 - 4 = " << ToInt(Subtract(three, four));
    std::cout << "\n 6 / 3 = " << ToInt(Divide(six, three));
    std::cout << "\n 3 / 6 = " << ToInt(Divide(three, six));
    auto looloolooo = Add(Exp(thousand, three), Add(Exp(ten, six), thousand));
    auto looloolool = Successor(looloolooo);
    std::cout << "\n 10^9 + 10^6 + 10^3 + 1 = " << ToInt(looloolool);

    // calculate the golden ratio by using a Church numeral to
    // apply the funtion 'f(x) = 1 + 1/x' a thousand times
    std::cout << "\n golden ratio = " <<
        thousand([](double x){ return 1.0 + 1.0 / x; })(1.0) << "\n";
}
