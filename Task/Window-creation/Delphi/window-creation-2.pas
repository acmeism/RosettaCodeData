program Project3;

uses
  Windows,
  Messages;

var
  WndClass: TWndClass;
  Msg: TMsg;
  winT, winL: Integer;

// Initial height/width of the window
const
  winW: Integer = 800;
  winH: Integer = 600;

// Callback function to processes messages sent to the window
function WindowProc(hWnd,Msg,wParam,lParam:Integer): Integer; stdcall;
begin
  // Trap the WM_DESTROY message
  if (Msg = WM_DESTROY) then PostQuitMessage(0);
  Result := DefWindowProc(hWnd,Msg,wParam,lParam);
end;

begin
  // Fill the WndClass structure with the window class attributes
  // to be registered by the RegisterClass function
  with WndClass do
    begin
      lpszClassName:= 'Form1';
      lpfnWndProc :=  @WindowProc; // Pointer to our message handling callback
      style := CS_OWNDC or         // Request a unique device context
               CS_VREDRAW or       // Redraw window when resized vertically
               CS_HREDRAW;         // Redraw window when resized horizontally
      hInstance := hInstance;      // The instance that the window procedure of this class is within
      hbrBackground := HBRUSH(COLOR_BTNFACE+1); // Background colour of the window
    end;

  // Register the window class for use by CreateWindow
  RegisterClass(WndClass);

  // Calculate initial top and left positions of the window
  winT := (GetSystemMetrics(SM_CYFULLSCREEN) - winH) div 2;
  winL := (GetSystemMetrics(SM_CXFULLSCREEN) - winW) div 2;

  // Create the window
  CreateWindow(WndClass.lpszClassName,              // Class name
               'Form1',                             // Window name
               WS_OVERLAPPEDWINDOW or WS_VISIBLE,   // Window style
               winL,                                // Horizontal Position (Left)
               winT,                                // Vertical Position (Top)
               winW,                                // Width
               winH,                                // Height
               0,                                   // Window parent/owner handle
               0,                                   // Menu handle
               hInstance,                           // Handle to application instance
               nil);                                // Pointer to window creation data

 // Handle messages
 while GetMessage(Msg,0,0,0) do
   DispatchMessage(Msg);

end.
