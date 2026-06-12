#include <iostream>
#include <map>
#include <utility>

using namespace std;

template<typename T>
class FixedMap : private T
{
    // Two standard maps are used to implement FixedMap.  One as a private
    // base class which will allow the values (but not the keys) to be modified.
    // Members of a private base class are not exposed to the derived class which will
    // prevent keys from being added or deleted. Another map will hold copies of
    // the initial values.
    T m_defaultValues;

public:
    FixedMap(T map)
    : T(map), m_defaultValues(move(map)){}

    // Expose members of the base class that do not modify the map.
    using T::cbegin;
    using T::cend;
    using T::empty;
    using T::find;
    using T::size;

    // Also expose members that can modify values but not add or remove keys.
    using T::at;
    using T::begin;
    using T::end;

    // The [] operator will normally add a new key if the key is not already in the
    // map.  Instead, throw an error if the key is missing.
    auto& operator[](typename T::key_type&& key)
    {
        // Make it behave like at()
        return this->at(forward<typename T::key_type>(key));
    }

    // Instead of removing a key, change the sematics of erase() to restore
    // the original value of the key.
    void erase(typename T::key_type&& key)
    {
        T::operator[](key) = m_defaultValues.at(key);
    }

    // Also change the sematics of clear() to restore all keys
    void clear()
    {
        // Reset the base class using the defaults
        T::operator=(m_defaultValues);
    }

};

// Print the contents of a map
auto PrintMap = [](const auto &map)
{
    for(auto &[key, value] : map)
    {
        cout << "{" << key << " : " << value << "} ";
    }
    cout << "\n\n";
};

int main(void)
{
    // Create a fixed map based on the standard map
    cout << "Map intialized with values\n";
    FixedMap<map<string, int>> fixedMap ({
        {"a", 1},
        {"b", 2}});
    PrintMap(fixedMap);

    cout << "Change the values of the keys\n";
    fixedMap["a"] = 55;
    fixedMap["b"] = 56;
    PrintMap(fixedMap);

    cout << "Reset the 'a' key\n";
    fixedMap.erase("a");
    PrintMap(fixedMap);

    cout << "Change the values the again\n";
    fixedMap["a"] = 88;
    fixedMap["b"] = 99;
    PrintMap(fixedMap);

    cout << "Reset all keys\n";
    fixedMap.clear();
    PrintMap(fixedMap);

    try
    {
        // Adding or retrieving a missing key is a run time error
        cout << "Try to add a new key\n";
        fixedMap["newKey"] = 99;
    }
    catch (exception &ex)
    {
        cout << "error: " << ex.what();
    }
}
