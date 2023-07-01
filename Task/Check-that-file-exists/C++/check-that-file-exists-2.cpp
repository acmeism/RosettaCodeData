#include <iostream>
#include <filesystem>

void file_exists(const std::filesystem::path& path) {
    std::cout << path;
    if (  std::filesystem::exists(path) ) {
    	if ( std::filesystem::is_directory(path) ) {
    		std::cout << " is a directory" << std::endl;
    	} else {
    		std::cout << " exists with a file size of " << std::filesystem::file_size(path) << " bytes." << std::endl;
    	}
    } else {
        std::cout << " does not exist" << std::endl;
    }
}

int main() {
	file_exists("input.txt");
	file_exists("zero_length.txt");
	file_exists("docs/input.txt");
	file_exists("docs/zero_length.txt");
}
