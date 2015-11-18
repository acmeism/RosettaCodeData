#include <iostream>
#include <boost/filesystem.hpp>

using namespace boost::filesystem;

int main(int argc, char *argv[])
{
    for (int i = 1; i < argc; ++i) {
        path p(argv[i]);

        if (exists(p) && is_directory(p))
            std::cout << "'" << argv[i] << "' is" << (!is_empty(p) ? " not" : "") << " empty\n";
        else
            std::cout << "dir '" << argv[i] << "' could not be found\n";
    }
}
