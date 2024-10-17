program Execute_Brain;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils;

const
  DataSize = 1024;                           // Size of Data segment
  MaxNest = 1000;                           // Maximum nesting depth of []

function Readkey: Char;
var
  InputRec: TInputRecord;
  NumRead: Cardinal;
  KeyMode: DWORD;
  StdIn: THandle;
begin
  StdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(StdIn, KeyMode);
  SetConsoleMode(StdIn, 0);

  repeat
    ReadConsoleInput(StdIn, InputRec, 1, NumRead);
    if (InputRec.EventType and KEY_EVENT <> 0) and InputRec.Event.KeyEvent.bKeyDown then
    begin
      if InputRec.Event.KeyEvent.AsciiChar <> #0 then
      begin
        Result := InputRec.Event.KeyEvent.UnicodeChar;
        Break;
      end;
    end;
  until FALSE;

  SetConsoleMode(StdIn, KeyMode);
end;

procedure ExecuteBF(Source: string);
var
  Dp: pByte;                          // Used as the Data Pointer
  DataSeg: Pointer;                        // Start of the DataSegment (Cell 0)
  Ip: pChar;                          // Used as instruction Pointer
  LastIp: Pointer;                        // Last adr of code.
  JmpStack: array[0..MaxNest - 1] of pChar;   // Stack to Keep track of active "[" locations
  JmpPnt: Integer;                        // Stack pointer ^^
  JmpCnt: Word;                           // Used to count brackets when skipping forward.

begin

  // Set up then data segment
  getmem(DataSeg, dataSize);
  Dp := DataSeg;
//  fillbyte(dp^,dataSize,0);
  FillChar(Dp^, DataSize, 0);

  // Set up the JmpStack
  JmpPnt := -1;

  // Set up Instruction Pointer
  Ip := @Source[1];
  LastIp := @Source[length(Source)];
  if Ip = nil then
    exit;

  // Main Execution loop
  repeat { until Ip > LastIp }
    case Ip^ of
      '<':
        dec(Dp);
      '>':
        inc(Dp);
      '+':
        inc(Dp^);
      '-':
        dec(Dp^);
      '.':
        write(chr(Dp^));
      ',':
        Dp^ := ord(ReadKey);
      '[':
        if Dp^ = 0 then
        begin
             // skip forward until matching bracket;
          JmpCnt := 1;
          while (JmpCnt > 0) and (Ip <= LastIp) do
          begin
            inc(Ip);
            case Ip^ of
              '[':
                inc(JmpCnt);
              ']':
                dec(JmpCnt);
              #0:
                begin
                  Writeln('Error brackets don''t match');
                  halt;
                end;
            end;
          end;
        end
        else
        begin
             // Add location to Jump stack
          inc(JmpPnt);
          JmpStack[JmpPnt] := Ip;
        end;
      ']':
        if Dp^ > 0 then
             // Jump Back to matching [
          Ip := JmpStack[JmpPnt]
        else             // Remove Jump from stack
          dec(JmpPnt);
    end;
    inc(Ip);
  until Ip > LastIp;
  freemem(DataSeg, dataSize);
end;

const
  HelloWorldWiki = '++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>' +
    '---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.';
  pressESCtoCont = '>[-]+++++++[<++++++++++>-]<->>[-]+++++++[<+++++++++++' +
    '+>-]<->>[-]++++[<++++++++>-]+>[-]++++++++++[<++++++++' +
    '++>-]>[-]++++++++[<++++++++++++++>-]<.++.+<.>..<<.<<.' +
    '-->.<.>>.>>+.-----.<<.[<<+>>-]<<.>>>>.-.++++++.<++++.' +
    '+++++.>+.<<<<++.>+[>+<--]>++++...';
  waitForEsc = '[-]>[-]++++[<+++++++>-]<->[-]>+[[-]<<[>+>+<<-]' + '>>[<' +
    '<+>>-],<[->-<]>]';

begin
  // Execute "Hello World" example from Wikipedia
  ExecuteBF(HelloWorldWiki);

  // Print text "press ESC to continue....." and wait for ESC to be pressed
  ExecuteBF(pressESCtoCont + waitForEsc);
end.
