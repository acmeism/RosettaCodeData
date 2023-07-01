#include <windows.h>
#include <string>
#include <iostream>

const int BMP_SIZE = 720, LINE_LEN = 120, BORDER = 100;

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
        HANDLE file = CreateFile( path.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS,
                                  FILE_ATTRIBUTE_NORMAL, NULL );
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
class tree {
public:
    tree() {
        bmp.create( BMP_SIZE, BMP_SIZE ); bmp.clear();
        clr[0] = RGB( 90, 30, 0 );   clr[1] = RGB( 255, 255, 0 );
        clr[2] = RGB( 0, 255, 255 ); clr[3] = RGB( 255, 255, 255 );
        clr[4] = RGB( 255, 0, 0 );   clr[5] = RGB( 0, 100, 190 );
    }
    void draw( int it, POINT a, POINT b ) {
        if( !it ) return;
        bmp.setPenColor( clr[it % 6] );
        POINT df = { b.x - a.x, a.y -  b.y }; POINT c = { b.x - df.y, b.y - df.x };
        POINT d = { a.x - df.y, a.y - df.x };
        POINT e = { d.x + ( ( df.x - df.y ) / 2 ), d.y - ( ( df.x + df.y ) / 2 )};
        drawSqr( a, b, c, d ); draw( it - 1, d, e ); draw( it - 1, e, c );
    }
    void save( std::string p ) { bmp.saveBitmap( p ); }
private:
    void drawSqr( POINT a, POINT b, POINT c, POINT d ) {
        HDC dc = bmp.getDC();
        MoveToEx( dc, a.x, a.y, NULL );
        LineTo( dc, b.x, b.y );
        LineTo( dc, c.x, c.y );
        LineTo( dc, d.x, d.y );
        LineTo( dc, a.x, a.y );
    }
    myBitmap bmp;
    DWORD clr[6];
};
int main( int argc, char* argv[] ) {
    POINT ptA = { ( BMP_SIZE >> 1 ) - ( LINE_LEN >> 1 ), BMP_SIZE - BORDER },
          ptB = { ptA.x + LINE_LEN, ptA.y };
    tree t; t.draw( 12, ptA, ptB );
    // change this path
    t.save( "?:/pt.bmp" );
    return 0;
}
