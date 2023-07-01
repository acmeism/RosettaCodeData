#include <windows.h>
#include <ctime>
#include <string>
#include <iostream>

const int BMP_SIZE = 600;

class myBitmap {
public:
    myBitmap() : pen( NULL ), brush( NULL ), clr( 0 ), wid( 1 ) {}
    ~myBitmap() {
        DeleteObject( pen ); DeleteObject( brush );
        DeleteDC( hdc ); DeleteObject( bmp );
    }
    bool create( int w, int h ) {
        BITMAPINFO bi;
        ZeroMemory( &bi, sizeof( bi ) );
        bi.bmiHeader.biSize        = sizeof( bi.bmiHeader );
        bi.bmiHeader.biBitCount    = sizeof( DWORD ) * 8;
        bi.bmiHeader.biCompression = BI_RGB;
        bi.bmiHeader.biPlanes      = 1;
        bi.bmiHeader.biWidth       =  w;
        bi.bmiHeader.biHeight      = -h;

        HDC dc = GetDC( GetConsoleWindow() );
        bmp = CreateDIBSection( dc, &bi, DIB_RGB_COLORS, &pBits, NULL, 0 );
        if( !bmp ) return false;

        hdc = CreateCompatibleDC( dc );
        SelectObject( hdc, bmp );
        ReleaseDC( GetConsoleWindow(), dc );

        width = w; height = h;
        return true;
    }
    void clear( BYTE clr = 0 ) {
        memset( pBits, clr, width * height * sizeof( DWORD ) );
    }
    void setBrushColor( DWORD bClr ) {
        if( brush ) DeleteObject( brush );
        brush = CreateSolidBrush( bClr );
        SelectObject( hdc, brush );
    }
    void setPenColor( DWORD c ) {
        clr = c; createPen();
    }
    void setPenWidth( int w ) {
        wid = w; createPen();
    }
    void saveBitmap( std::string path ) {
        BITMAPFILEHEADER fileheader;
        BITMAPINFO       infoheader;
        BITMAP           bitmap;
        DWORD            wb;

        GetObject( bmp, sizeof( bitmap ), &bitmap );
        DWORD* dwpBits = new DWORD[bitmap.bmWidth * bitmap.bmHeight];

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

        HANDLE file = CreateFile( path.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL );
        WriteFile( file, &fileheader, sizeof( BITMAPFILEHEADER ), &wb, NULL );
        WriteFile( file, &infoheader.bmiHeader, sizeof( infoheader.bmiHeader ), &wb, NULL );
        WriteFile( file, dwpBits, bitmap.bmWidth * bitmap.bmHeight * 4, &wb, NULL );
        CloseHandle( file );

        delete [] dwpBits;
    }
    HDC getDC() const     { return hdc; }
    int getWidth() const  { return width; }
    int getHeight() const { return height; }
private:
    void createPen() {
        if( pen ) DeleteObject( pen );
        pen = CreatePen( PS_SOLID, wid, clr );
        SelectObject( hdc, pen );
    }
    HBITMAP bmp; HDC    hdc;
    HPEN    pen; HBRUSH brush;
    void    *pBits; int    width, height, wid;
    DWORD    clr;
};
class chaos {
public:
    void start() {
        POINT org;
        fillPts(); initialPoint( org ); initColors();
        int cnt = 0, i;
        bmp.create( BMP_SIZE, BMP_SIZE );
        bmp.clear( 255 );

        while( cnt++ < 1000000 ) {
            switch( rand() % 6 ) {
                case 0: case 3: i = 0; break;
                case 1: case 5: i = 1; break;
                case 2: case 4: i = 2;
            }
            setPoint( org, myPoints[i], i );
        }
        // --- edit this path --- //
        bmp.saveBitmap( "F:/st.bmp" );
    }
private:
    void setPoint( POINT &o, POINT v, int i ) {
        POINT z;
        o.x = ( o.x + v.x ) >> 1; o.y = ( o.y + v.y ) >> 1;
        SetPixel( bmp.getDC(), o.x, o.y, colors[i] );
    }
    void fillPts() {
        int a = BMP_SIZE - 1;
        myPoints[0].x = BMP_SIZE >> 1; myPoints[0].y = 0;
        myPoints[1].x = 0; myPoints[1].y = myPoints[2].x = myPoints[2].y = a;
    }
    void initialPoint( POINT& p ) {
        p.x = ( BMP_SIZE >> 1 ) + rand() % 2 ? rand() % 30 + 10 : -( rand() % 30 + 10 );
        p.y = ( BMP_SIZE >> 1 ) + rand() % 2 ? rand() % 30 + 10 : -( rand() % 30 + 10 );
    }
    void initColors() {
        colors[0] = RGB( 255, 0, 0 );
        colors[1] = RGB( 0, 255, 0 );
        colors[2] = RGB( 0, 0, 255 );
    }

    myBitmap bmp;
    POINT myPoints[3];
    COLORREF colors[3];
};
int main( int argc, char* argv[] ) {
    srand( ( unsigned )time( 0 ) );
    chaos c; c.start();
    return 0;
}
