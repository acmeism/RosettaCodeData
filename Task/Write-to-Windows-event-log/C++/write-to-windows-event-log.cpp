#include <iostream>
#include <sstream>

int main(int argc, char *argv[]) {
    using namespace std;

#if _WIN32
    if (argc != 5) {
        cout << "Usage : " << argv[0] << " (type)  (id)  (source string) (description>)\n";
        cout << "    Valid types: SUCCESS, ERROR, WARNING, INFORMATION\n";
    } else {
        stringstream ss;
        ss << "EventCreate /t " << argv[1] << " /id " << argv[2] << " /l APPLICATION /so " << argv[3] << " /d \"" << argv[4] << "\"";
        system(ss.str().c_str());
    }
#else
    cout << "Not implemented for *nix, only windows.\n";
#endif

    return 0;
}
