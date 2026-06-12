#include <iostream>
#include <filesystem>

int main() {
    for (std::filesystem::path file : { "picture.jpg",
                                        "http://mywebsite.com/picture/image.png",
                                        "myuniquefile.longextension",
                                        "IAmAFileWithoutExtension",
                                        "/path/to.my/file",
                                        "file.odd_one",
                                        "thisismine." }) {
        std::cout << file << " has extension : " << file.extension() << '\n' ;
    }
}
