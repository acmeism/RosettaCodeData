#include <winsock2.h>
#include <ws2tcpip.h>
#include <iostream>

int main() {
	WSADATA wsaData;
	WSAStartup( MAKEWORD( 2, 2 ), &wsaData );

	addrinfo *result = NULL;
	addrinfo hints;

	ZeroMemory( &hints, sizeof( hints ) );
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;

	getaddrinfo( "74.125.45.100", "80", &hints, &result ); // http://www.google.com

	SOCKET s = socket( result->ai_family, result->ai_socktype, result->ai_protocol );

	connect( s, result->ai_addr, (int)result->ai_addrlen );

	freeaddrinfo( result );

	send( s, "GET / HTTP/1.0\n\n", 16, 0 );

	char buffer[512];
	int bytes;

	do {
		bytes = recv( s, buffer, 512, 0 );

		if ( bytes > 0 )
			std::cout.write(buffer, bytes);
	} while ( bytes > 0 );

	return 0;
}
