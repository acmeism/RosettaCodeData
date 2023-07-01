#include <windows.h>
#include <string>
#include <iostream>

const int BMP_SIZE = 612;

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
class sierpinski {
public:
    void draw( int o ) {
        colors[0] = 0xff0000; colors[1] = 0x00ff33; colors[2] = 0x0033ff;
        colors[3] = 0xffff00; colors[4] = 0x00ffff; colors[5] = 0xffffff;
        bmp.create( BMP_SIZE, BMP_SIZE ); HDC dc = bmp.getDC();
        drawTri( dc, 0, 0, ( float )BMP_SIZE, ( float )BMP_SIZE, o / 2 );
        bmp.setPenColor( colors[0] ); MoveToEx( dc, BMP_SIZE >> 1, 0, NULL );
        LineTo( dc, 0, BMP_SIZE - 1 ); LineTo( dc, BMP_SIZE - 1, BMP_SIZE - 1 );
        LineTo( dc, BMP_SIZE >> 1, 0 ); bmp.saveBitmap( "./st.bmp" );
    }
private:
    void drawTri( HDC dc, float l, float t, float r, float b, int i ) {
        float w = r - l, h = b - t, hh = h / 2.f, ww = w / 4.f;
        if( i ) {
            drawTri( dc, l + ww, t, l + ww * 3.f, t + hh, i - 1 );
            drawTri( dc, l, t + hh, l + w / 2.f, t + h, i - 1 );
            drawTri( dc, l + w / 2.f, t + hh, l + w, t + h, i - 1 );
        }
        bmp.setPenColor( colors[i % 6] );
        MoveToEx( dc, ( int )( l + ww ),          ( int )( t + hh ), NULL );
        LineTo  ( dc, ( int )( l + ww * 3.f ),    ( int )( t + hh ) );
        LineTo  ( dc, ( int )( l + ( w / 2.f ) ), ( int )( t + h ) );
        LineTo  ( dc, ( int )( l + ww ),          ( int )( t + hh ) );
    }
    myBitmap bmp;
    DWORD colors[6];
};
int main(int argc, char* argv[]) {
    sierpinski s; s.draw( 12 );
    return 0;
}
