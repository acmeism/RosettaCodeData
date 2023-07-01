program Draw_a_pixel;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows,
  Messages,
  SysUtils;

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
begin
  LWndClass.hInstance := hInstance;
  with LWndClass do
  begin
    lpszClassName := 'OneRedPixel';
    Style := CS_PARENTDC or CS_BYTEALIGNCLIENT;
    hIcon := LoadIcon(hInstance, 'MAINICON');
    lpfnWndProc := @WindowProc;
    hbrBackground := COLOR_BTNFACE + 1;
    hCursor := LoadCursor(0, IDC_ARROW);
  end;

  RegisterClass(LWndClass);
  hMainHandle := CreateWindow(LWndClass.lpszClassName,
    'Draw a red pixel on (100,100)', WS_CAPTION or WS_MINIMIZEBOX or WS_SYSMENU
    or WS_VISIBLE, ((GetSystemMetrics(SM_CXSCREEN) - W) div 2), ((GetSystemMetrics
    (SM_CYSCREEN) - H) div 2), W, H, 0, 0, hInstance, nil);
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

  // Fill bg with white
  FillRect(Dc, ps.rcPaint, CreateSolidBrush($FFFFFF));

  // Do the magic
  SetPixel(Dc, 100, 100, $FF);

  EndPaint(Handle, ps);
end;

begin
  CreateWin(320, 240);
  ShowModal();
end.
