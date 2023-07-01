#include <direct.h>
#include <io.h>
#include <sys/stat.h>

int main(void) {
    int f;

    f = _creat("output.txt", _S_IWRITE);
    if (f == -1) {
        perror("Unable to create file");
    } else {
        _close(f);
    }

    if (_mkdir("docs") == -1) {
        perror("Unable to create directory");
    }

    f = _creat("\\output.txt", _S_IWRITE);
    if (f == -1) {
        perror("Unable to create file");
    } else {
        _close(f);
    }

    if (_mkdir("\\docs") == -1) {
        perror("Unable to create directory");
    }

    return 0;
}
