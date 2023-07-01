#include <map>
#include <iostreams>

int main()
{
  // Create the map.
  std::map<int, double> exampleMap;

  // Choose our key
  int myKey = 7;

  // Choose our value
  double myValue = 3.14;

  // Assign a value to the map with the specified key.
  exampleMap[myKey] = myValue;

  // Retrieve the value
  double myRetrievedValue = exampleMap[myKey];

  // Display our retrieved value.
  std::cout << myRetrievedValue << std::endl;

  // main() must return 0 on success.
  return 0;
}
