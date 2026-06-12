program AudioAlarm;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Bass;

procedure Wait(sec: Cardinal; verbose: Boolean = False);
begin
  while sec > 0 do
  begin
    if verbose then
      Writeln(sec);
    Sleep(1000); // 1s
    dec(sec);
  end;
end;

function QueryMp3File: string;
begin
  while True do
  begin
    Writeln('Enter name of .mp3 file to play (without extension) : ');
    Readln(Result);
    Result := Result + '.mp3';
    if not FileExists(Result) then
    begin
      Writeln('The file "' + Result + '" not exist');
      Continue;
    end;
    Break;
  end;
end;

function QueryIntNumber(): Integer;
var
  val: string;
begin
  Result := 0;
  repeat
    Writeln('Enter number of seconds delay > 0 : ');
    Readln(val);

    if not TryStrToInt(val, Result) then
    begin
      Writeln('"', val, '" is not a valid number.');
      Continue;
    end;
    if Result <= 0 then
    begin
      Writeln('"', val, '" must be greater then 0');
      Continue;
    end;
  until Result > 0;
end;

function CreateMusic(MusicName: string): HSTREAM;
var
  buffer: PChar;
begin
  buffer := pchar(MusicName);

	// Initialize audio - default device, 44100hz, stereo, 16 bits
  if not BASS_Init(-1, 44100, 0, 0, nil) then
    Writeln('Error initializing audio!');

  Result := BASS_StreamCreateFile(False, buffer, 0, 0, 0{$IFDEF UNICODE}     or
    BASS_UNICODE {$ENDIF});
  if Result = 0 then
   Writeln('Error on load music!');
end;

procedure Play(Music:HSTREAM);
begin
  if not BASS_ChannelPlay(Music, True) then
    Writeln('Error playing music!');
end;

var
  Music: HSTREAM;
  MusicName: string;
  delay: Cardinal;

begin
  MusicName := QueryMp3File;
  delay := QueryIntNumber;
  Music := CreateMusic(MusicName);

  Wait(delay, True);

  Play(Music);

  Readln;
  BASS_StreamFree(Music);
  BASS_Free();
end.
