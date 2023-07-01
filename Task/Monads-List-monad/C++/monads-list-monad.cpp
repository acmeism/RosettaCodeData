#include <iostream>
#include <vector>

using namespace std;

// std::vector can be a list monad.  Use the >> operator as the bind function
template <typename T>
auto operator>>(const vector<T>& monad, auto f)
{
    // Declare a vector of the same type that the function f returns
    vector<remove_reference_t<decltype(f(monad.front()).front())>> result;
    for(auto& item : monad)
    {
        // Apply the function f to each item in the monad. f will return a
        // new list monad containing 0 or more items.
        const auto r = f(item);
        // Concatenate the results of f with previous results
        result.insert(result.end(), begin(r), end(r));
    }

    return result;
}

// The Pure function returns a vector containing one item, t
auto Pure(auto t)
{
    return vector{t};
}

// A function to double items in the list monad
auto Double(int i)
{
    return Pure(2 * i);
}

// A function to increment items
auto Increment(int i)
{
    return Pure(i + 1);
}

// A function to convert items to a string
auto NiceNumber(int i)
{
    return Pure(to_string(i) + " is a nice number\n");
}

// A function to map an item to a sequence ending at max value
// for example: 497 -> {497, 498, 499, 500}
auto UpperSequence = [](auto startingVal)
{
    const int MaxValue = 500;
    vector<decltype(startingVal)> sequence;
    while(startingVal <= MaxValue)
        sequence.push_back(startingVal++);
    return sequence;
};

// Print contents of a vector
void PrintVector(const auto& vec)
{
    cout << " ";
    for(auto value : vec)
    {
        cout << value << " ";
    }
    cout << "\n";
}

// Print the Pythagorean triples
void PrintTriples(const auto& vec)
{
    cout << "Pythagorean triples:\n";
    for(auto it = vec.begin(); it != vec.end();)
    {
        auto x = *it++;
        auto y = *it++;
        auto z = *it++;

        cout << x << ", " << y << ", " << z << "\n";
    }
    cout << "\n";
}

int main()
{
    // Apply Increment, Double, and NiceNumber to {2, 3, 4} using the monadic bind
    auto listMonad =
        vector<int> {2, 3, 4} >>
        Increment >>
        Double >>
        NiceNumber;

    PrintVector(listMonad);

    // Find Pythagorean triples using the list monad.  The 'x' monad list goes
    // from 1 to the max; the 'y' goes from the current 'x' to the max; and 'z'
    // goes from the current 'y' to the max.  The last bind returns the triplet
    // if it is Pythagorean, otherwise it returns an empty list monad.
    auto pythagoreanTriples = UpperSequence(1) >>
        [](int x){return UpperSequence(x) >>
        [x](int y){return UpperSequence(y) >>
        [x, y](int z){return (x*x + y*y == z*z) ? vector{x, y, z} : vector<int>{};};};};

    PrintTriples(pythagoreanTriples);
}
