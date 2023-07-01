program rcExceuteBrainF;

uses
     Crt;

Const
  DataSize= 1024;                           // Size of Data segment
  MaxNest=  1000;                           // Maximum nesting depth of []

procedure ExecuteBF(Source: string);
var
  Dp:       pByte;                          // Used as the Data Pointer
  DataSeg:  Pointer;                        // Start of the DataSegment (Cell 0)
  Ip:       pChar;                          // Used as instruction Pointer
  LastIp:   Pointer;                        // Last adr of code.
  JmpStack: array[0..MaxNest-1] of pChar;   // Stack to Keep track of active "[" locations
  JmpPnt:   Integer;                        // Stack pointer ^^
  JmpCnt:   Word;                           // Used to count brackets when skipping forward.


begin

  // Set up then data segment
  getmem(DataSeg,dataSize);
  dp:=DataSeg;
  fillbyte(dp^,dataSize,0);

  // Set up the JmpStack
  JmpPnt:=-1;

  // Set up Instruction Pointer
  Ip:=@Source[1];
  LastIp:=@Source[length(source)];
  if Ip=nil then exit;

  // Main Execution loop
  repeat { until Ip > LastIp }
    Case Ip^ of
      '<': dec(dp);
      '>': inc(dp);
      '+': inc(dp^);
      '-': dec(dp^);
      '.': write(stdout,chr(dp^));
      ',': dp^:=ord(readkey);
      '[': if dp^=0 then
           begin
             // skip forward until matching bracket;
             JmpCnt:=1;
             while (JmpCnt>0) and (ip<=lastip) do
             begin
               inc(ip);
               Case ip^ of
                 '[': inc(JmpCnt);
                 ']': dec(JmpCnt);
                 #0:  begin
                        Writeln(StdErr,'Error brackets don''t match');
                        halt;
                      end;
                end;
             end;
           end else begin
             // Add location to Jump stack
             inc(JmpPnt);
             JmpStack[jmpPnt]:=ip;
           end;
      ']': if dp^>0 then
             // Jump Back to matching [
             ip:=JmpStack[jmpPnt]
           else
             // Remove Jump from stack
             dec(jmpPnt);
    end;
    inc(ip);
  until Ip>lastIp;
  freemem(DataSeg,dataSize);
end;

Const
  HelloWorldWiki = '++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>'+
                   '---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.';

  pressESCtoCont = '>[-]+++++++[<++++++++++>-]<->>[-]+++++++[<+++++++++++'+
                   '+>-]<->>[-]++++[<++++++++>-]+>[-]++++++++++[<++++++++'+
                   '++>-]>[-]++++++++[<++++++++++++++>-]<.++.+<.>..<<.<<.'+
                   '-->.<.>>.>>+.-----.<<.[<<+>>-]<<.>>>>.-.++++++.<++++.'+
                   '+++++.>+.<<<<++.>+[>+<--]>++++...';
  waitForEsc     = '[-]>[-]++++[<+++++++>-]<->[-]>+[[-]<<[>+>+<<-]'+'>>[<'+
                   '<+>>-],<[->-<]>]';

begin
  // Execute "Hello World" example from Wikipedia
  ExecuteBF(HelloWorldWiki);

  // Print text "press ESC to continue....." and wait for ESC to be pressed
  ExecuteBF(pressESCtoCont+waitForEsc);
end.
