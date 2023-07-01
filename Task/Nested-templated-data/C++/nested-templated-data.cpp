#include <iostream>
#include <set>
#include <tuple>
#include <vector>

using namespace std;

// print a single payload
template<typename P>
void PrintPayloads(const P &payloads, int index, bool isLast)
{
    if(index < 0 || index >= (int)size(payloads)) cout << "null";
    else cout << "'" << payloads[index] << "'";
    if (!isLast) cout << ", ";  // add a comma between elements
}

// print a tuple of playloads
template<typename P, typename... Ts>
void PrintPayloads(const P &payloads, tuple<Ts...> const& nestedTuple, bool isLast = true)
{
    std::apply  // recursively call PrintPayloads on each element of the tuple
    (
        [&payloads, isLast](Ts const&... tupleArgs)
        {
            size_t n{0};
            cout << "[";
            (PrintPayloads(payloads, tupleArgs, (++n == sizeof...(Ts)) ), ...);
            cout << "]";
            cout << (isLast ? "\n" : ",\n");
        }, nestedTuple
    );
}

// find the unique index of a single index (helper for the function below)
void FindUniqueIndexes(set<int> &indexes, int index)
{
    indexes.insert(index);
}

// find the unique indexes in the tuples
template<typename... Ts>
void FindUniqueIndexes(set<int> &indexes, std::tuple<Ts...> const& nestedTuple)
{
    std::apply
    (
        [&indexes](Ts const&... tupleArgs)
        {
            (FindUniqueIndexes(indexes, tupleArgs),...);
        }, nestedTuple
    );
}

// print the payloads that were not used
template<typename P>
void PrintUnusedPayloads(const set<int> &usedIndexes, const P &payloads)
{
    for(size_t i = 0; i < size(payloads); i++)
    {
        if(usedIndexes.find(i) == usedIndexes.end() ) cout << payloads[i] << "\n";
    }
}

int main()
{
    // define the playloads, they can be in most containers
    vector payloads {"Payload#0", "Payload#1", "Payload#2", "Payload#3", "Payload#4", "Payload#5", "Payload#6"};
    const char *shortPayloads[] {"Payload#0", "Payload#1", "Payload#2", "Payload#3"}; // as a C array

    // define the indexes as a nested tuple
    auto tpl = make_tuple(make_tuple(
        make_tuple(1, 2),
        make_tuple(3, 4, 1),
        5));

    cout << "Mapping indexes to payloads:\n";
    PrintPayloads(payloads, tpl);

    cout << "\nFinding unused payloads:\n";
    set<int> usedIndexes;
    FindUniqueIndexes(usedIndexes, tpl);
    PrintUnusedPayloads(usedIndexes, payloads);

    cout << "\nMapping to some out of range payloads:\n";
    PrintPayloads(shortPayloads, tpl);

    return 0;
}
