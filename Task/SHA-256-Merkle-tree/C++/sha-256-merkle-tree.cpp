#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <vector>
#include <openssl/sha.h>

class sha256_exception : public std::exception {
public:
    const char* what() const noexcept override {
        return "SHA-256 error";
    }
};

class sha256 {
public:
    sha256() { reset(); }
    sha256(const sha256&) = delete;
    sha256& operator=(const sha256&) = delete;
    void reset() {
        if (SHA256_Init(&context_) == 0)
            throw sha256_exception();
    }
    void update(const void* data, size_t length) {
        if (SHA256_Update(&context_, data, length) == 0)
            throw sha256_exception();
    }
    std::vector<unsigned char> digest() {
        std::vector<unsigned char> digest(SHA256_DIGEST_LENGTH);
        if (SHA256_Final(digest.data(), &context_) == 0)
            throw sha256_exception();
        return digest;
    }
private:
    SHA256_CTX context_;
};

std::string digest_to_string(const std::vector<unsigned char>& digest) {
    std::ostringstream out;
    out << std::hex << std::setfill('0');
    for (size_t i = 0; i < digest.size(); ++i)
        out << std::setw(2) << static_cast<int>(digest[i]);
    return out.str();
}

std::vector<unsigned char> sha256_merkle_tree(std::istream& in, size_t block_size) {
    std::vector<std::vector<unsigned char>> hashes;
    std::vector<char> buffer(block_size);
    sha256 md;
    while (in) {
        in.read(buffer.data(), block_size);
        size_t bytes = in.gcount();
        if (bytes == 0)
            break;
        md.reset();
        md.update(buffer.data(), bytes);
        hashes.push_back(md.digest());
    }
    if (hashes.empty())
        return {};
    size_t length = hashes.size();
    while (length > 1) {
        size_t j = 0;
        for (size_t i = 0; i < length; i += 2, ++j) {
            auto& digest1 = hashes[i];
            auto& digest_out = hashes[j];
            if (i + 1 < length) {
                auto& digest2 = hashes[i + 1];
                md.reset();
                md.update(digest1.data(), digest1.size());
                md.update(digest2.data(), digest2.size());
                digest_out = md.digest();
            } else {
                digest_out = digest1;
            }
        }
        length = j;
    }
    return hashes[0];
}

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "usage: " << argv[0] << " filename\n";
        return EXIT_FAILURE;
    }
    std::ifstream in(argv[1], std::ios::binary);
    if (!in) {
        std::cerr << "Cannot open file " << argv[1] << ".\n";
        return EXIT_FAILURE;
    }
    try {
        std::cout << digest_to_string(sha256_merkle_tree(in, 1024)) << '\n';
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << "\n";
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
