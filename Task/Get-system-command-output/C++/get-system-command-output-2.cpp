#include <iostream>
#include <string>
#include <vector>
#include <boost/process.hpp>

// Returns a vector containing names of files in the specified directory
// by capturing the output of the "ls" command, which is specific to
// Unix-like operating systems.
// Obviously there are better ways of listing files in a directory; this
// is just an example showing how to use boost::process.
std::vector<std::string> list_files(const std::string& directory) {
    namespace bp = boost::process;
    bp::ipstream input;
    bp::child process("/bin/ls", directory, bp::std_out > input);
    std::vector<std::string> files;
    std::string file;
    while (getline(input, file))
        files.push_back(file);
    process.wait();
    if (process.exit_code() != 0)
        throw std::runtime_error("Process did not complete successfully.");
    return files;
}

int main(int argc, char** argv) {
    try {
        for (auto file : list_files(argc > 1 ? argv[1] : "."))
            std::cout << file << '\n';
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << '\n';
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
