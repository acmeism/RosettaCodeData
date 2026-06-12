#include <iostream>
#include <list>

using namespace std;

void PrintContainer(const auto& container)
{
    cout << "[ ";
    for_each(container.begin(), container.end(), [](auto item){cout << item << " ";});
    cout << "]";
}

int main()
{
    list<int> numbers{6, 81, 243, 14, 25, 49, 123, 69, 11};

    // a lambda to remove the minimum item
    auto removeMin = [](auto& container)
    {
        auto minIterator = min_element(container.begin(), container.end());
        auto minValue = *minIterator;
        container.erase(minIterator);
        return minValue;
    };

    while(numbers.size() > 1)
    {
        PrintContainer(numbers);
        auto minValue = removeMin(numbers);
        auto nextMinValue = removeMin(numbers);
        auto sum = minValue + nextMinValue;
        numbers.push_back(sum);
        cout << "  =>  " << minValue << " + " << nextMinValue << " = " << sum << "\n";
    }
    cout << "Final list: "; PrintContainer(numbers); cout << "\n";
}
