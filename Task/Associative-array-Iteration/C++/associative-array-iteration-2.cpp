std::map<std::string, int> myDict;
myDict["hello"] = 1;
myDict["world"] = 2;
myDict["!"] = 3;

// iterating over key-value pairs:
for (std::map<std::string, int>::iterator it = myDict.begin(); it != myDict.end(); ++it) {
    // the thing pointed to by the iterator is an std::pair<const std::string, int>&
    const std::string& key = it->first;
    int& value = it->second;
    std::cout << "key = " << key << ", value = " << value << std::endl;
}
