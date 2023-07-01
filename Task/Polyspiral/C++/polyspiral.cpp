#include <windows.h>
#include <sstream>
#include <ctime>

const float PI = 3.1415926536f, TWO_PI = 2.f * PI;
class vector2
{
public:
    vector2( float a = 0, float b = 0 ) { set( a, b ); }
    void set( float a, float b ) { x = a; y = b; }
    void rotate( float r ) {
        float _x = x, _y = y,
               s = sinf( r ), c = cosf( r ),
               a = _x * c - _y * s, b = _x * s + _y * c;
        x = a; y = b;
    }
    vector2 add( const vector2& v ) {
        x += v.x; y += v.y;
        return *this;
    }
    float x, y;
};
class myBitmap
{
public:
    myBitmap() : pen( NULL ), brush( NULL ), clr( 0 ), wid( 1 ) {}
    ~myBitmap(){
        DeleteObject( pen );
        DeleteObject( brush );
        DeleteDC( hdc );
        DeleteObject( bmp );
    }
    bool create( int w, int h ){
        BITMAPINFO    bi;
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
    void clear( BYTE clr = 0 ){
        memset( pBits, clr, width * height * sizeof( DWORD ) );
    }
    void setBrushColor( DWORD bClr ){
        if( brush ) DeleteObject( brush );
        brush = CreateSolidBrush( bClr );
        SelectObject( hdc, brush );
    }
    void setPenColor( DWORD c ){
        clr = c; createPen();
    }
    void setPenWidth( int w ){
        wid = w; createPen();
    }
    void saveBitmap( std::string path ){
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
    void createPen(){
        if( pen ) DeleteObject( pen );
        pen = CreatePen( PS_SOLID, wid, clr );
        SelectObject( hdc, pen );
    }
    HBITMAP bmp; HDC hdc;
    HPEN pen; HBRUSH brush;
    void *pBits; int width, height, wid;
    DWORD clr;
};
int main( int argc, char* argv[] ) {
    srand( unsigned( time( 0 ) ) );
    myBitmap bmp;
    bmp.create( 600, 600 ); bmp.clear();
    HDC dc = bmp.getDC();
    float fs = ( TWO_PI ) / 100.f;
    int index = 0;
    std::string a = "f://users//images//test", b;
    float ang, len;
    vector2 p1, p2;

    for( float step = 0.1f; step < 5.1f; step += .05f ) {
        ang = 0; len = 2;
        p1.set( 300, 300 );
        bmp.setPenColor( RGB( rand() % 50 + 200, rand() % 300 + 220, rand() % 50 + 200 ) );
        for( float xx = 0; xx < TWO_PI; xx += fs ) {
            MoveToEx( dc, (int)p1.x, (int)p1.y, NULL );
            p2.set( 0, len ); p2.rotate( ang ); p2.add( p1 );
            LineTo( dc, (int)p2.x, (int)p2.y );
            p1 = p2; ang += step; len += step;
        }
        std::ostringstream ss; ss << index++;
        b = a + ss.str() + ".bmp";
        bmp.saveBitmap( b );
        bmp.clear();
    }
    return 0;
}
