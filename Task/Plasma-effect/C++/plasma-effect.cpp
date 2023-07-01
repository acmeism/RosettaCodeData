#include <windows.h>
#include <math.h>
#include <string>

const int BMP_SIZE = 240, MY_TIMER = 987654;

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
    DWORD* bits()          { return ( DWORD* )pBits; }
private:
    void createPen() {
        if( pen ) DeleteObject( pen );
        pen = CreatePen( PS_SOLID, wid, clr );
        SelectObject( hdc, pen );
    }
    HBITMAP bmp; HDC    hdc;
    HPEN    pen; HBRUSH brush;
    void    *pBits; int width, height, wid;
    DWORD    clr;
};
class plasma
{
public:
    plasma() {
        currentTime = 0; _WD = BMP_SIZE >> 1; _WV = BMP_SIZE << 1;
        _bmp.create( BMP_SIZE, BMP_SIZE ); _bmp.clear();
        plasma1 = new BYTE[BMP_SIZE * BMP_SIZE * 4];
        plasma2 = new BYTE[BMP_SIZE * BMP_SIZE * 4];
        int i, j, dst = 0;
        double temp;
        for( j = 0; j < BMP_SIZE * 2; j++ ) {
            for( i = 0; i < BMP_SIZE * 2; i++ ) {
                plasma1[dst] = ( BYTE )( 128.0 + 127.0 * ( cos( ( double )hypot( BMP_SIZE - j, BMP_SIZE - i ) / 64.0 ) ) );
                plasma2[dst] = ( BYTE )( ( sin( ( sqrt( 128.0 + ( BMP_SIZE - i ) * ( BMP_SIZE - i ) +
                               ( BMP_SIZE - j ) * ( BMP_SIZE - j ) ) - 4.0 ) / 32.0 ) + 1 ) * 90.0 );
                dst++;
            }
        }
    }
    void update() {
        DWORD dst;
        BYTE a, c1,c2, c3;
        currentTime += ( double )( rand() % 2 + 1 );

        int x1 = _WD + ( int )( ( _WD - 1 ) * sin( currentTime  / 137 ) ),
            x2 = _WD + ( int )( ( _WD - 1 ) * sin( -currentTime /  75 ) ),
            x3 = _WD + ( int )( ( _WD - 1 ) * sin( -currentTime / 125 ) ),
            y1 = _WD + ( int )( ( _WD - 1 ) * cos( currentTime  / 123 ) ),
            y2 = _WD + ( int )( ( _WD - 1 ) * cos( -currentTime /  85 ) ),
            y3 = _WD + ( int )( ( _WD - 1 ) * cos( -currentTime / 108 ) );

        int src1 = y1 * _WV + x1, src2 = y2 * _WV + x2, src3 = y3 * _WV + x3;

        DWORD* bits = _bmp.bits();
        for( int j = 0; j < BMP_SIZE; j++ ) {
            dst = j * BMP_SIZE;
            for( int i= 0; i < BMP_SIZE; i++ ) {
                a = plasma2[src1] + plasma1[src2] + plasma2[src3];
                c1 = a << 1; c2 = a << 2; c3 = a << 3;
                bits[dst + i] = RGB( c1, c2, c3 );
                src1++; src2++; src3++;
            }
            src1 += BMP_SIZE; src2 += BMP_SIZE; src3 += BMP_SIZE;
        }
        draw();
    }
    void setHWND( HWND hwnd ) { _hwnd = hwnd; }
private:
    void draw() {
        HDC dc = _bmp.getDC(), wdc = GetDC( _hwnd );
        BitBlt( wdc, 0, 0, BMP_SIZE, BMP_SIZE, dc, 0, 0, SRCCOPY );
        ReleaseDC( _hwnd, wdc );
    }
    myBitmap _bmp; HWND _hwnd; float _ang;
    BYTE *plasma1, *plasma2;
    double currentTime; int _WD, _WV;
};
class wnd
{
public:
    wnd() { _inst = this; }
    int wnd::Run( HINSTANCE hInst ) {
        _hInst = hInst; _hwnd = InitAll();
        SetTimer( _hwnd, MY_TIMER, 15, NULL );
        _plasma.setHWND( _hwnd );
        ShowWindow( _hwnd, SW_SHOW );
        UpdateWindow( _hwnd );
        MSG msg;
        ZeroMemory( &msg, sizeof( msg ) );
        while( msg.message != WM_QUIT ) {
            if( PeekMessage( &msg, NULL, 0, 0, PM_REMOVE ) != 0 ) {
                TranslateMessage( &msg );
                DispatchMessage( &msg );
            }
        }
        return UnregisterClass( "_MY_PLASMA_", _hInst );
    }
private:
    void wnd::doPaint( HDC dc ) { _plasma.update(); }
    void wnd::doTimer()         { _plasma.update(); }
    static int WINAPI wnd::WndProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam ) {
        switch( msg ) {
            case WM_PAINT: {
                    PAINTSTRUCT ps;
                    _inst->doPaint( BeginPaint( hWnd, &ps ) );
                    EndPaint( hWnd, &ps );
                    return 0;
                }
            case WM_DESTROY: PostQuitMessage( 0 ); break;
            case WM_TIMER: _inst->doTimer(); break;
            default: return DefWindowProc( hWnd, msg, wParam, lParam );
        }
        return 0;
    }
    HWND InitAll() {
        WNDCLASSEX wcex;
        ZeroMemory( &wcex, sizeof( wcex ) );
        wcex.cbSize        = sizeof( WNDCLASSEX );
        wcex.style         = CS_HREDRAW | CS_VREDRAW;
        wcex.lpfnWndProc   = ( WNDPROC )WndProc;
        wcex.hInstance     = _hInst;
        wcex.hCursor       = LoadCursor( NULL, IDC_ARROW );
        wcex.hbrBackground = ( HBRUSH )( COLOR_WINDOW + 1 );
        wcex.lpszClassName = "_MY_PLASMA_";

        RegisterClassEx( &wcex );

        RECT rc = { 0, 0, BMP_SIZE, BMP_SIZE };
        AdjustWindowRect( &rc, WS_SYSMENU | WS_CAPTION, FALSE );
        int w = rc.right - rc.left, h = rc.bottom - rc.top;
        return CreateWindow( "_MY_PLASMA_", ".: Plasma -- PJorente :.", WS_SYSMENU, CW_USEDEFAULT, 0, w, h, NULL, NULL, _hInst, NULL );
    }
    static wnd* _inst; HINSTANCE _hInst; HWND _hwnd; plasma _plasma;
};
wnd* wnd::_inst = 0;
int APIENTRY WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow ) {
    wnd myWnd;
    return myWnd.Run( hInstance );
}
