#include <winsock2.h>
#include <assert.h>

// link winsock (MSVC extension. Ignored by MinGW)
#pragma comment(lib, "ws2_32.lib")

const char MESSAGE[] = "hello socket world";

int main() {
    WSADATA wsa;
    WSAStartup(MAKEWORD(2, 2), &wsa);
    SOCKET s = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in server = {
       .sin_family = AF_INET,
       .sin_port = htons(256),
       .sin_addr.s_addr = inet_addr("127.0.0.1")
    };

    assert(connect(s, (struct sockaddr *)&server, sizeof(server)) == 0);
    send(s, MESSAGE, sizeof(MESSAGE) / sizeof(char), 0);

    closesocket(s);
    WSACleanup();
    return 0;
}
