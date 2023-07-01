#include <windows.h>
#include <string>
#include <math.h>

//--------------------------------------------------------------------------------------------------
using namespace std;

//--------------------------------------------------------------------------------------------------
const int BMP_SIZE = 300, MY_TIMER = 987654, CENTER = BMP_SIZE >> 1, SEC_LEN = CENTER - 20,
          MIN_LEN = SEC_LEN - 20, HOUR_LEN = MIN_LEN - 20;
const float PI = 3.1415926536f;

//--------------------------------------------------------------------------------------------------
class vector2
{
public:
    vector2() { x = y = 0; }
    vector2( int a, int b ) { x = a; y = b; }
    void set( int a, int b ) { x = a; y = b; }
    void rotate( float angle_r )
    {
	float _x = static_cast<float>( x ),
	      _y = static_cast<float>( y ),
	       s = sinf( angle_r ),
	       c = cosf( angle_r ),
	       a = _x * c - _y * s,
	       b = _x * s + _y * c;

	x = static_cast<int>( a );
	y = static_cast<int>( b );
    }
    int x, y;
};
//--------------------------------------------------------------------------------------------------
class myBitmap
{
public:
    myBitmap() : pen( NULL ), brush( NULL ), clr( 0 ), wid( 1 ) {}
    ~myBitmap()
    {
	DeleteObject( pen );
	DeleteObject( brush );
	DeleteDC( hdc );
	DeleteObject( bmp );
    }

    bool create( int w, int h )
    {
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

    void clear( BYTE clr = 0 )
    {
	memset( pBits, clr, width * height * sizeof( DWORD ) );
    }

    void setBrushColor( DWORD bClr )
    {
	if( brush ) DeleteObject( brush );
	brush = CreateSolidBrush( bClr );
	SelectObject( hdc, brush );
    }

    void setPenColor( DWORD c )
    {
	clr = c;
	createPen();
    }

    void setPenWidth( int w )
    {
	wid = w;
	createPen();
    }

    void saveBitmap( string path )
    {
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
    void createPen()
    {
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
//--------------------------------------------------------------------------------------------------
class clock
{
public:
    clock()
    {
	_bmp.create( BMP_SIZE, BMP_SIZE );
	_bmp.clear( 100 );
	_bmp.setPenWidth( 2 );
	_ang = DegToRadian( 6 );
    }
	
    void setNow()
    {
	GetLocalTime( &_sysTime );
	draw();
    }

    float DegToRadian( float degree ) { return degree * ( PI / 180.0f ); }

    void setHWND( HWND hwnd ) { _hwnd = hwnd; }

private:
    void drawTicks( HDC dc )
    {
	vector2 line;
	_bmp.setPenWidth( 1 );
	for( int x = 0; x < 60; x++ )
	{
	    line.set( 0, 50 );
	    line.rotate( static_cast<float>( x + 30 ) * _ang );
	    MoveToEx( dc, CENTER - static_cast<int>( 2.5f * static_cast<float>( line.x ) ), CENTER - static_cast<int>( 2.5f * static_cast<float>( line.y ) ), NULL );
	    LineTo( dc, CENTER - static_cast<int>( 2.81f * static_cast<float>( line.x ) ), CENTER - static_cast<int>( 2.81f * static_cast<float>( line.y ) ) );
	}

	_bmp.setPenWidth( 3 );
	for( int x = 0; x < 60; x += 5 )
	{
	    line.set( 0, 50 );
	    line.rotate( static_cast<float>( x + 30 ) * _ang );
	    MoveToEx( dc, CENTER - static_cast<int>( 2.5f * static_cast<float>( line.x ) ), CENTER - static_cast<int>( 2.5f * static_cast<float>( line.y ) ), NULL );
	    LineTo( dc, CENTER - static_cast<int>( 2.81f * static_cast<float>( line.x ) ), CENTER - static_cast<int>( 2.81f * static_cast<float>( line.y ) ) );
	}
    }

    void drawHands( HDC dc )
    {
	float hp = DegToRadian( ( 30.0f * static_cast<float>( _sysTime.wMinute ) ) / 60.0f );
	int h = ( _sysTime.wHour > 12 ? _sysTime.wHour - 12 : _sysTime.wHour ) * 5;
		
	_bmp.setPenWidth( 3 );
	_bmp.setPenColor( RGB( 0, 0, 255 ) );
	drawHand( dc, HOUR_LEN, ( _ang * static_cast<float>( 30 + h ) ) + hp );

	_bmp.setPenColor( RGB( 0, 128, 0 ) );
	drawHand( dc, MIN_LEN, _ang * static_cast<float>( 30 + _sysTime.wMinute ) );

	_bmp.setPenWidth( 2 );
	_bmp.setPenColor( RGB( 255, 0, 0 ) );
	drawHand( dc, SEC_LEN, _ang * static_cast<float>( 30 + _sysTime.wSecond ) );
    }

    void drawHand( HDC dc, int len, float ang )
    {
	vector2 line;
	line.set( 0, len );
	line.rotate( ang );
	MoveToEx( dc, CENTER, CENTER, NULL );
	LineTo( dc, line.x + CENTER, line.y + CENTER );
    }

    void draw()
    {
	HDC dc = _bmp.getDC();

	_bmp.setBrushColor( RGB( 250, 250, 250 ) );
	Ellipse( dc, 0, 0, BMP_SIZE, BMP_SIZE );
	_bmp.setBrushColor( RGB( 230, 230, 230 ) );
	Ellipse( dc, 10, 10, BMP_SIZE - 10, BMP_SIZE - 10 );

	drawTicks( dc );
	drawHands( dc );

	_bmp.setPenColor( 0 ); _bmp.setBrushColor( 0 );
	Ellipse( dc, CENTER - 5, CENTER - 5, CENTER + 5, CENTER + 5 );

	_wdc = GetDC( _hwnd );
	BitBlt( _wdc, 0, 0, BMP_SIZE, BMP_SIZE, dc, 0, 0, SRCCOPY );
	ReleaseDC( _hwnd, _wdc );
    }

    myBitmap   _bmp;
    HWND       _hwnd;
    HDC        _wdc;
    SYSTEMTIME _sysTime;
    float      _ang;
};
//--------------------------------------------------------------------------------------------------
class wnd
{
public:
    wnd() { _inst = this; }
    int wnd::Run( HINSTANCE hInst )
    {
	_hInst = hInst;
	_hwnd = InitAll();
	SetTimer( _hwnd, MY_TIMER, 1000, NULL );
	_clock.setHWND( _hwnd );

	ShowWindow( _hwnd, SW_SHOW );
	UpdateWindow( _hwnd );

	MSG msg;
	ZeroMemory( &msg, sizeof( msg ) );
	while( msg.message != WM_QUIT )
	{
	    if( PeekMessage( &msg, NULL, 0, 0, PM_REMOVE ) != 0 )
	    {
		TranslateMessage( &msg );
		DispatchMessage( &msg );
	    }
	}
	return UnregisterClass( "_MY_CLOCK_", _hInst );
    }
private:
    void wnd::doPaint( HDC dc ) { _clock.setNow(); }
    void wnd::doTimer()         { _clock.setNow(); }
    static int WINAPI wnd::WndProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
    {
	switch( msg )
	{
	    case WM_DESTROY: PostQuitMessage( 0 ); break;
	    case WM_PAINT:
	    {
		PAINTSTRUCT ps;
		HDC dc = BeginPaint( hWnd, &ps );
		_inst->doPaint( dc );
		EndPaint( hWnd, &ps );
		return 0;
	    }
	    case WM_TIMER: _inst->doTimer(); break;
	    default:
		return DefWindowProc( hWnd, msg, wParam, lParam );
	}
	return 0;
    }

    HWND InitAll()
    {
	WNDCLASSEX wcex;
	ZeroMemory( &wcex, sizeof( wcex ) );
	wcex.cbSize           = sizeof( WNDCLASSEX );
	wcex.style           = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc   = ( WNDPROC )WndProc;
	wcex.hInstance     = _hInst;
	wcex.hCursor       = LoadCursor( NULL, IDC_ARROW );
	wcex.hbrBackground = ( HBRUSH )( COLOR_WINDOW + 1 );
	wcex.lpszClassName = "_MY_CLOCK_";

	RegisterClassEx( &wcex );

	RECT rc = { 0, 0, BMP_SIZE, BMP_SIZE };
	AdjustWindowRect( &rc, WS_SYSMENU | WS_CAPTION, FALSE );
	int w = rc.right - rc.left, h = rc.bottom - rc.top;
	return CreateWindow( "_MY_CLOCK_", ".: Clock -- PJorente :.", WS_SYSMENU, CW_USEDEFAULT, 0, w, h, NULL, NULL, _hInst, NULL );
    }

    static wnd* _inst;
    HINSTANCE  _hInst;
    HWND       _hwnd;
    clock      _clock;
};
wnd* wnd::_inst = 0;
//--------------------------------------------------------------------------------------------------
int APIENTRY _tWinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow )
{
    wnd myWnd;
    return myWnd.Run( hInstance );
}
//--------------------------------------------------------------------------------------------------
