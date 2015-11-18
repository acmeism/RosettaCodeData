#include "stdafx.h"
#include <windows.h>
#include <stdlib.h>

const int BMP_WID = 410, BMP_HEI = 230, MAX_BALLS = 120;

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
    HDC getDC() const     { return hdc; }
    int getWidth() const  { return width; }
    int getHeight() const { return height; }
private:
    void createPen() {
        if( pen ) DeleteObject( pen );
        pen = CreatePen( PS_SOLID, wid, clr );
        SelectObject( hdc, pen );
    }
    HBITMAP bmp;
    HDC     hdc;
    HPEN    pen;
    HBRUSH  brush;
    void    *pBits;
    int     width, height, wid;
    DWORD   clr;
};
class point {
public:
    int x; float y;
    void set( int a, float b ) { x = a; y = b; }
};
typedef struct {
    point position, offset;
    bool alive, start;
}ball;
class galton {
public :
    galton() {
        bmp.create( BMP_WID, BMP_HEI );
        initialize();
    }
    void setHWND( HWND hwnd ) { _hwnd = hwnd; }
    void simulate() {
        draw(); update(); Sleep( 1 );
    }
private:
    void draw() {
        bmp.clear();
        bmp.setPenColor( RGB( 0, 255, 0 ) );
        bmp.setBrushColor( RGB( 0, 255, 0 ) );
        int xx, yy;
        for( int y = 3; y < 14; y++ ) {
            yy = 10 * y;
            for( int x = 0; x < 41; x++ ) {
                xx = 10 * x;
                if( pins[y][x] )
                    Rectangle( bmp.getDC(), xx - 3, yy - 3, xx + 3, yy + 3 );
            }
        }
        bmp.setPenColor( RGB( 255, 0, 0 ) );
        bmp.setBrushColor( RGB( 255, 0, 0 ) );
        ball* b;
        for( int x = 0; x < MAX_BALLS; x++ ) {
            b = &balls[x];
            if( b->alive )
                Rectangle( bmp.getDC(), static_cast<int>( b->position.x - 3 ), static_cast<int>( b->position.y - 3 ),
                                        static_cast<int>( b->position.x + 3 ), static_cast<int>( b->position.y + 3 ) );
        }
        for( int x = 0; x < 70; x++ ) {
            if( cols[x] > 0 ) {
                xx = 10 * x;
                Rectangle( bmp.getDC(), xx - 3, 160, xx + 3, 160 + cols[x] );
            }
        }
        HDC dc = GetDC( _hwnd );
        BitBlt( dc, 0, 0, BMP_WID, BMP_HEI, bmp.getDC(), 0, 0, SRCCOPY );
        ReleaseDC( _hwnd, dc );
    }
    void update() {
        ball* b;
        for( int x = 0; x < MAX_BALLS; x++ ) {
            b = &balls[x];
            if( b->alive ) {
                b->position.x += b->offset.x; b->position.y += b->offset.y;
                if( x < MAX_BALLS - 1 && !b->start && b->position.y > 50.0f ) {
                    b->start = true;
                    balls[x + 1].alive = true;
                }
                int c = ( int )b->position.x, d = ( int )b->position.y + 6;
                if( d > 10 || d < 41 ) {
                    if( pins[d / 10][c / 10] ) {
                        if( rand() % 30 < 15 ) b->position.x -= 10;
                        else b->position.x += 10;
                    }
                }
                if( b->position.y > 160 ) {
                    b->alive = false;
                    cols[c / 10] += 1;
                }
            }
        }
    }
    void initialize() {
        for( int x = 0; x < MAX_BALLS; x++ ) {
            balls[x].position.set( 200, -10 );
            balls[x].offset.set( 0, 0.5f );
            balls[x].alive = balls[x].start = false;
        }
        balls[0].alive = true;
        for( int x = 0; x < 70; x++ )
            cols[x] = 0;
        for( int y = 0; y < 70; y++ )
            for( int x = 0; x < 41; x++ )
                pins[x][y] = false;
        int p;
        for( int y = 0; y < 11; y++ ) {
            p = ( 41 / 2 ) - y;
            for( int z = 0; z < y + 1; z++ ) {
                pins[3 + y][p] = true;
                p += 2;
            }
        }
    }
    myBitmap bmp;
    HWND _hwnd;
    bool pins[70][40];
    ball balls[MAX_BALLS];
    int cols[70];
};
class wnd {
public:
    int wnd::Run( HINSTANCE hInst ) {
        _hInst = hInst;
        _hwnd = InitAll();
        _gtn.setHWND( _hwnd );
        ShowWindow( _hwnd, SW_SHOW );
        UpdateWindow( _hwnd );
        MSG msg;
        ZeroMemory( &msg, sizeof( msg ) );
        while( msg.message != WM_QUIT ) {
            if( PeekMessage( &msg, NULL, 0, 0, PM_REMOVE ) != 0 ) {
                TranslateMessage( &msg );
                DispatchMessage( &msg );
            } else _gtn.simulate();
        }
        return UnregisterClass( "_GALTON_", _hInst );
    }
private:
    static int WINAPI wnd::WndProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam ) {
        switch( msg ) {
            case WM_DESTROY: PostQuitMessage( 0 ); break;
            default:
                return static_cast<int>( DefWindowProc( hWnd, msg, wParam, lParam ) );
        }
        return 0;
    }
    HWND InitAll() {
        WNDCLASSEX wcex;
        ZeroMemory( &wcex, sizeof( wcex ) );
        wcex.cbSize           = sizeof( WNDCLASSEX );
        wcex.style           = CS_HREDRAW | CS_VREDRAW;
        wcex.lpfnWndProc   = ( WNDPROC )WndProc;
        wcex.hInstance     = _hInst;
        wcex.hCursor       = LoadCursor( NULL, IDC_ARROW );
        wcex.hbrBackground = ( HBRUSH )( COLOR_WINDOW + 1 );
        wcex.lpszClassName = "_GALTON_";
        RegisterClassEx( &wcex );
        RECT rc;
        SetRect( &rc, 0, 0, BMP_WID, BMP_HEI );
        AdjustWindowRect( &rc, WS_CAPTION, FALSE );
        return CreateWindow( "_GALTON_", ".: Galton Box -- PJorente :.", WS_SYSMENU, CW_USEDEFAULT, 0, rc.right - rc.left, rc.bottom - rc.top, NULL, NULL, _hInst, NULL );
    }
    HINSTANCE _hInst;
    HWND      _hwnd;
    galton    _gtn;
};
int APIENTRY WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow ) {
    srand( GetTickCount() );
    wnd myWnd;
    return myWnd.Run( hInstance );
}
