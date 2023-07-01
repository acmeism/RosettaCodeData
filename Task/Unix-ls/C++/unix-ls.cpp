#include <iostream>
#include <set>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main(void)
{
    fs::path p(fs::current_path());
    std::set<std::string> tree;

    for (auto it = fs::directory_iterator(p); it != fs::directory_iterator(); ++it)
        tree.insert(it->path().filename().native());

    for (auto entry : tree)
        std::cout << entry << '\n';
}
