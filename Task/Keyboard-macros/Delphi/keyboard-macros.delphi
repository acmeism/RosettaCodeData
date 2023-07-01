program Key_Bindings_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Winapi.Windows,
  Messages,
  Classes;

type
  // Class of application without window
  TWindowlessApplication = class
  private
    Terminated: Boolean;
    F7_id: Word;
    F6_id: Word;
    WIN_A: Word;
    procedure HandleMessage;
  public
    Handle: THandle;
    constructor Create;
    destructor Destroy;
    procedure Run;
  end;

{ TWindowlessApplication }

constructor TWindowlessApplication.Create;
begin
  // Allocate handle to receve a mensages
  Handle := CreateWindowEx(WS_EX_TOOLWINDOW, 'TWindowlessApplication', '',
    WS_POPUP, 0, 0, 0, 0, 0, 0, HInstance, nil);

  // Set the key bind for WIN+A, F6 and F7
  WIN_A := GlobalAddAtom('Hotkey_WIN_A');
  F6_id := GlobalAddAtom('Hotkey_F6');
  F7_id := GlobalAddAtom('Hotkey_F7');

  RegisterHotKey(Handle, WIN_A, MOD_WIN, ord('A'));
  RegisterHotKey(Handle, F6_id, 0, VK_F6);
  RegisterHotKey(Handle, F7_id, 0, VK_F7);

  // Set flag to keep running application
  Terminated := false;
end;

destructor TWindowlessApplication.Destroy;
begin
  // Remove key bind
  UnRegisterHotKey(Handle, WIN_A);
  UnRegisterHotKey(Handle, F6_id);
  UnRegisterHotKey(Handle, F7_id);

  GlobalDeleteAtom(WIN_A);
  GlobalDeleteAtom(F6_id);
  GlobalDeleteAtom(F7_id);

  // Deallocate handle
  DeallocateHWnd(Handle);
end;

procedure TWindowlessApplication.Run;
begin
  // Application loop
  repeat
    // Deal with new messages
    HandleMessage();
  until Terminated;
end;

procedure TWindowlessApplication.HandleMessage;
var
  Msg: TMsg;
begin
  // Check for new messages
  if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
  begin
    // Extract it
    PeekMessageW(Msg, 0, 0, 0, PM_REMOVE);

    // Check if Msg is a HOTKEY mensage
    if Msg.message = WM_HOTKEY then
    begin
      // Check if the hotkey is for Win+A
      if Msg.wParam = WIN_A then
      begin
        // Report and terminate
        writeln('Win + A pressed !'#10);
        writeln('Bye bye');
        Terminated := true;
      end;

      // Check if the hotkey is for F6
      if Msg.wParam = F6_id then
      begin
        // Report and terminate
        writeln('F6 pressed !');
      end;

      // Check if the hotkey is for F7
      if Msg.wParam = F7_id then
      begin
        // Report and terminate
        writeln('F7 pressed !');
      end;
    end;
  end;
end;

var
  App: TWindowlessApplication;

begin
  App := TWindowlessApplication.Create;
  Writeln('Waiting user press F6 ou F7, then press WIN+A for terminate');
  App.Run;
  App.Destroy;
  readln;
end.
