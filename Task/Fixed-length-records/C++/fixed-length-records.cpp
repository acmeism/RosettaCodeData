#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iostream>

void reverse(std::istream& in, std::ostream& out) {
    constexpr size_t record_length = 80;
    char record[record_length];
    while (in.read(record, record_length)) {
        std::reverse(std::begin(record), std::end(record));
        out.write(record, record_length);
    }
    out.flush();
}

int main(int argc, char** argv) {
    std::ifstream in("infile.dat", std::ios_base::binary);
    if (!in) {
        std::cerr << "Cannot open input file\n";
        return EXIT_FAILURE;
    }
    std::ofstream out("outfile.dat", std::ios_base::binary);
    if (!out) {
        std::cerr << "Cannot open output file\n";
        return EXIT_FAILURE;
    }
    try {
        in.exceptions(std::ios_base::badbit);
        out.exceptions(std::ios_base::badbit);
        reverse(in, out);
    } catch (const std::exception& ex) {
        std::cerr << "I/O error: " << ex.what() << '\n';
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
