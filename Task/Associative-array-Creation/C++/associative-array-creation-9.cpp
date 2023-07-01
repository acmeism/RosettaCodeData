double myValue = 0.0;
std::map<int, double>::iterator myIterator = exampleMap.find(myKey);
if(exampleMap.end() != myIterator)
{
  // Return the value for that key.
  myValue = myIterator->second;
}
