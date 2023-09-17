#include <cstdio>

int main() {
	// Creates and opens a temporary file with a unique auto-generated filename.
    // If the program closes the file, the file is automatically deleted.
	// The file is also automatically deleted if the program exits normally.
    std::FILE* temp_file_pointer = std::tmpfile();

    // Using functions which take a file pointer as an argument
    std::fputs("Hello world", temp_file_pointer);
    std::rewind(temp_file_pointer);
    char buffer[12];
    std::fgets(buffer, sizeof buffer, temp_file_pointer);
    printf(buffer);
}
