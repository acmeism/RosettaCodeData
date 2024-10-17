program Flush_the_keyboard_buffer;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows;

var
  StdIn: THandle;

begin
  StdIn := GetStdHandle(STD_INPUT_HANDLE);
  Writeln('Press any key you want, they will be erased:');
  Sleep(5000);
  FlushConsoleInputBuffer(StdIn);
  Writeln('Now press any key you want, they will NOT be erased:');
  readln;
end.
