#include <stdio.h>

... (above code for ParseIPv4OrIPv6 goes here) ...

unsigned short htons ( unsigned short us )
{
	return ( ((unsigned char*)&us)[0] << 8 ) + ((unsigned char*)&us)[1];
}

void dumpbin ( unsigned char* pbyBin, int nLen )
{
	int i;
	for ( i = 0; i < nLen; ++i )
	{
		printf ( "%02x", pbyBin[i] );
	}
}


void testcase ( const char* pszTest )
{
	unsigned char abyAddr[16];
	int bIsIPv6;
	int nPort;
	int bSuccess;

	printf ( "Test case '%s'\n", pszTest );
	const char* pszTextCursor = pszTest;
	bSuccess = ParseIPv4OrIPv6 ( &pszTextCursor, abyAddr, &nPort, &bIsIPv6 );
	if ( ! bSuccess )
	{
		printf ( "parse failed, at about index %d; rest: '%s'\n", pszTextCursor - pszTest, pszTextCursor );
		return;
	}
	
	printf ( "addr:  " );
	dumpbin ( abyAddr, bIsIPv6 ? 16 : 4 );
	printf ( "\n" );
	if ( 0 == nPort )
		printf ( "port absent" );
	else
		printf ( "port:  %d", htons ( nPort ) );
	printf ( "\n\n" );
	
}



int main ( int argc, char* argv[] )
{
	
	//The "localhost" IPv4 address
	testcase ( "127.0.0.1" );
	
	//The "localhost" IPv4 address, with a specified port (80)
	testcase ( "127.0.0.1:80" );
	//The "localhost" IPv6 address
	testcase ( "::1" );
	//The "localhost" IPv6 address, with a specified port (80)
	testcase ( "[::1]:80" );
	//Rosetta Code's primary server's public IPv6 address
	testcase ( "2605:2700:0:3::4713:93e3" );
	//Rosetta Code's primary server's public IPv6 address, with a specified port (80)
	testcase ( "[2605:2700:0:3::4713:93e3]:80" );
	
	//ipv4 space
	testcase ( "::ffff:192.168.173.22" );
	//ipv4 space with port
	testcase ( "[::ffff:192.168.173.22]:80" );
	//trailing compression
	testcase ( "1::" );
	//trailing compression with port
	testcase ( "[1::]:80" );
	//'any' address compression
	testcase ( "::" );
	//'any' address compression with port
	testcase ( "[::]:80" );
	
	return 0;
}
