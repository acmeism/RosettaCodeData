program Draw_a_pixel2;

{$APPTYPE CONSOLE}

uses
  Windows,
  Messages,
  SysUtils;

const
  WIN_WIDTH = 640;
  WIN_HEIGHT = 480;

var
  Msg: TMSG;
  LWndClass: TWndClass;
  hMainHandle: HWND;

procedure Paint(Handle: hWnd); forward;

procedure ReleaseResources;
begin
  PostQuitMessage(0);
end;

function WindowProc(hWnd, Msg: Longint; wParam: wParam; lParam: lParam): Longint; stdcall;
begin
  case Msg of
    WM_PAINT:
      Paint(hWnd);
    WM_DESTROY:
      ReleaseResources;
  end;
  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

procedure CreateWin(W, H: Integer);
var
  Title: string;
begin
  LWndClass.hInstance := hInstance;
  with LWndClass do
  begin
    lpszClassName := 'OneYellowPixel';
    Style := CS_PARENTDC or CS_BYTEALIGNCLIENT;
    hIcon := LoadIcon(hInstance, 'MAINICON');
    lpfnWndProc := @WindowProc;
    hbrBackground := COLOR_BTNFACE + 1;
    hCursor := LoadCursor(0, IDC_ARROW);
  end;

  Title := Format('Draw a YELLOW pixel random position in [%d, %d] ', [WIN_WIDTH,
    WIN_HEIGHT]);

  RegisterClass(LWndClass);
  hMainHandle := CreateWindow(LWndClass.lpszClassName, Pchar(Title), WS_CAPTION
    or WS_MINIMIZEBOX or WS_SYSMENU or WS_VISIBLE, ((GetSystemMetrics(SM_CXSCREEN)
    - W) div 2), ((GetSystemMetrics(SM_CYSCREEN) - H) div 2), W, H, 0, 0, hInstance, nil);
end;

procedure ShowModal;
begin
  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

procedure Paint(Handle: hWnd);
var
  ps: PAINTSTRUCT;
  Dc: HDC;
begin
  Dc := BeginPaint(Handle, ps);

  // Fill bg with black
  FillRect(Dc, ps.rcPaint, CreateSolidBrush($0));

  // Do the magic
  SetPixel(Dc, Random(WIN_WIDTH), Random(WIN_HEIGHT), $FFFF);

  EndPaint(Handle, ps);
end;

begin
  Randomize;
  CreateWin(WIN_WIDTH, WIN_HEIGHT);
  ShowModal();
end.
