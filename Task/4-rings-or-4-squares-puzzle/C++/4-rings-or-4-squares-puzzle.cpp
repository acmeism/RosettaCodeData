//C++14/17
#include <algorithm>//std::for_each
#include <iostream> //std::cout
#include <numeric>  //std::iota
#include <vector>   //std::vector, save solutions
#include <list>     //std::list, for fast erase

using std::begin, std::end, std::for_each;

//Generates all the valid solutions for the problem in the specified range [from, to)
std::list<std::vector<int>> combinations(int from, int to)
{
    if (from > to)
        return {};                          //Return nothing if limits are invalid

    auto pool = std::vector<int>(to - from);//Here we'll save our values
    std::iota(begin(pool), end(pool), from);//Populates pool

    auto solutions = std::list<std::vector<int>>{};   //List for the solutions

    //Brute-force calculation of valid values...
    for (auto a : pool)
        for (auto b : pool)
            for (auto c : pool)
                for (auto d : pool)
                    for (auto e : pool)
                        for (auto f : pool)
                            for (auto g : pool)
                                if ( a      == c + d
                                  && b + c  == e + f
                                  && d + e  ==     g )
                                    solutions.push_back({a, b, c, d, e, f, g});
    return solutions;
}

//Filter the list generated from "combinations" and return only lists with no repetitions
std::list<std::vector<int>> filter_unique(int from, int to)
{
    //Helper lambda to check repetitions:
    //If the count is > 1 for an element, there must be a repetition inside the range
    auto has_non_unique_values = [](const auto & range, auto target)
    {
        return std::count( begin(range), end(range), target) > 1;
    };

    //Generates all the solutions...
    auto results = combinations(from, to);

    //For each solution, find duplicates inside
    for (auto subrange = cbegin(results); subrange != cend(results); ++subrange)
    {
        bool repetition = false;

        //If some element is repeated, repetition becomes true
        for (auto x : *subrange)
            repetition |= has_non_unique_values(*subrange, x);

        if (repetition)    //If repetition is true, remove the current subrange from the list
        {
            results.erase(subrange);        //Deletes subrange from solutions
            --subrange;                     //Rewind to the last subrange analysed
        }
    }

    return results; //Finally return remaining results
}

template <class Container> //Template for the sake of simplicity
inline void print_range(const Container & c)
{
    for (const auto & subrange : c)
    {
        std::cout << "[";
        for (auto elem : subrange)
            std::cout << elem << ' ';
        std::cout << "\b]\n";
    }
}


int main()
{
    std::cout << "Unique-numbers combinations in range 1-7:\n";
    auto solution1 = filter_unique(1, 8);
    print_range(solution1);
    std::cout << "\nUnique-numbers combinations in range 3-9:\n";
    auto solution2 = filter_unique(3,10);
    print_range(solution2);
    std::cout << "\nNumber of combinations in range 0-9: "
              << combinations(0, 10).size() << "." << std::endl;

    return 0;
}
