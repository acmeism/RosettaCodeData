#include <windows.h>
#include <string>
using namespace std;

class myBitmap
{
public:
    myBitmap() : pen( NULL ) {}
    ~myBitmap()
    {
        DeleteObject( pen );
        DeleteDC( hdc );
        DeleteObject( bmp );
    }

    bool create( int w, int h )
    {
        BITMAPINFO	bi;
        ZeroMemory( &bi, sizeof( bi ) );
        bi.bmiHeader.biSize        = sizeof( bi.bmiHeader );
        bi.bmiHeader.biBitCount	   = sizeof( DWORD ) * 8;
	bi.bmiHeader.biCompression = BI_RGB;
	bi.bmiHeader.biPlanes	   = 1;
	bi.bmiHeader.biWidth	   =  w;
	bi.bmiHeader.biHeight	   = -h;
	HDC dc = GetDC( GetConsoleWindow() );
	bmp = CreateDIBSection( dc, &bi, DIB_RGB_COLORS, &pBits, NULL, 0 );
	if( !bmp ) return false;
	hdc = CreateCompatibleDC( dc );
	SelectObject( hdc, bmp );
	ReleaseDC( GetConsoleWindow(), dc );
	width = w; height = h;
	clear();
	return true;
    }

    void clear()
    {
	ZeroMemory( pBits, width * height * sizeof( DWORD ) );
    }

    void setPenColor( DWORD clr )
    {
	if( pen ) DeleteObject( pen );
	pen = CreatePen( PS_SOLID, 1, clr );
	SelectObject( hdc, pen );
    }

    void saveBitmap( string path )
    {
	BITMAPFILEHEADER fileheader;
	BITMAPINFO	 infoheader;
	BITMAP		 bitmap;
	DWORD*		 dwpBits;
	DWORD		 wb;
	HANDLE		 file;

	GetObject( bmp, sizeof( bitmap ), &bitmap );
	dwpBits = new DWORD[bitmap.bmWidth * bitmap.bmHeight];
	ZeroMemory( dwpBits, bitmap.bmWidth * bitmap.bmHeight * sizeof( DWORD ) );
	ZeroMemory( &infoheader, sizeof( BITMAPINFO ) );
	ZeroMemory( &fileheader, sizeof( BITMAPFILEHEADER ) );

	infoheader.bmiHeader.biBitCount = sizeof( DWORD ) * 8;
	infoheader.bmiHeader.biCompression = BI_RGB;
	infoheader.bmiHeader.biPlanes = 1;
	infoheader.bmiHeader.biSize = sizeof( infoheader.bmiHeader );
	infoheader.bmiHeader.biHeight = bitmap.bmHeight;
	infoheader.bmiHeader.biWidth = bitmap.bmWidth;
	infoheader.bmiHeader.biSizeImage = bitmap.bmWidth * bitmap.bmHeight * sizeof( DWORD );

	fileheader.bfType    = 0x4D42;
	fileheader.bfOffBits = sizeof( infoheader.bmiHeader ) + sizeof( BITMAPFILEHEADER );
	fileheader.bfSize    = fileheader.bfOffBits + infoheader.bmiHeader.biSizeImage;

	GetDIBits( hdc, bmp, 0, height, ( LPVOID )dwpBits, &infoheader, DIB_RGB_COLORS );

	file = CreateFile( path.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL );
	WriteFile( file, &fileheader, sizeof( BITMAPFILEHEADER ), &wb, NULL );
	WriteFile( file, &infoheader.bmiHeader, sizeof( infoheader.bmiHeader ), &wb, NULL );
	WriteFile( file, dwpBits, bitmap.bmWidth * bitmap.bmHeight * 4, &wb, NULL );
	CloseHandle( file );

	delete [] dwpBits;
    }

    HDC getDC()     { return hdc; }
    int getWidth()  { return width; }
    int getHeight() { return height; }

private:
    HBITMAP bmp;
    HDC	    hdc;
    HPEN    pen;
    void    *pBits;
    int	    width, height;
};
class fiboFractal
{
public:
    fiboFractal( int l )
    {
	bmp.create( 600, 440 );
	bmp.setPenColor( 0x00ff00 );
	createWord( l ); createFractal();
	bmp.saveBitmap( "path_to_save_bitmap" );
    }
private:
    void createWord( int l )
    {
	string a = "1", b = "0", c;
	l -= 2;
	while( l-- )
	{ c = b + a; a = b; b = c; }
	fWord = c;
    }

    void createFractal()
    {
	int n = 1, px = 10, dir,
	    py = 420, len = 1,
	    x = 0, y = -len, goingTo = 0;

	HDC dc = bmp.getDC();
	MoveToEx( dc, px, py, NULL );
	for( string::iterator si = fWord.begin(); si != fWord.end(); si++ )
	{
	    px += x; py += y;
	    LineTo( dc, px, py );
	    if( !( *si - 48 ) )
	    {	// odd
		if( n & 1 ) dir = 1;	// right
		else dir = 0;			// left
		switch( goingTo )
		{
		    case 0: // up
		        y = 0;
			if( dir ){ x = len; goingTo = 1; }
			else { x = -len; goingTo = 3; }
		    break;
		    case 1: // right
			x = 0;
			if( dir ) { y = len; goingTo = 2; }
			else { y = -len; goingTo = 0; }
		    break;
		    case 2: // down
			y = 0;
			if( dir ) { x = -len; goingTo = 3; }
			else { x = len; goingTo = 1; }
		    break;
		    case 3: // left
			x = 0;
			if( dir ) { y = -len; goingTo = 0; }
			else { y = len; goingTo = 2; }
		}
            }
	    n++;
        }
    }

    string fWord;
    myBitmap bmp;
};
int main( int argc, char* argv[] )
{
    fiboFractal ff( 23 );
    return system( "pause" );
}
