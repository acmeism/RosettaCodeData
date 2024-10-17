program ExecuteSystemCommand;

{$APPTYPE CONSOLE}

uses Windows, ShellApi;

begin
  ShellExecute(0, nil, 'cmd.exe', ' /c dir', nil, SW_HIDE);
end.
