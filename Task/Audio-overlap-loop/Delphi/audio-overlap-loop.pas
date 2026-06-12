program Audio_Overlap_Loop;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Winapi.Windows,
  Winapi.MMSystem;

function QueryIntNumber(Msg: string; min, max: Integer): Integer;
var
  val: string;
begin
  Result := 0;
  repeat
    Writeln(Msg);
    Readln(val);

    if not TryStrToInt(val, Result) then
    begin
      Writeln('"', val, '" is not a valid number.');
      Continue;
    end;
    if Result < min then
    begin
      Writeln('"', val, '" must be greater then ', min);
      Continue;
    end;

    if (Result > max) then
    begin
      Writeln('"', val, '" must be lower then ', max);
      Continue;
    end;

    Break;
  until True;
end;

function QueryFloatNumber(Msg: string; min, max: double): double;
var
  val: string;
begin
  Result := 0;
  repeat
    Writeln(Msg);
    Readln(val);
    // acept ',' ou '.' as decimal separator
    val := val.Replace(',',FormatSettings.DecimalSeparator);
    val := val.Replace('.',FormatSettings.DecimalSeparator);
    if not TryStrToFloat(val, Result) then
    begin
      Writeln('"', val, '" is not a valid number.');
      Continue;
    end;
    if Result < min then
    begin
      Writeln('"', val, '" must be greater then ', min);
      Continue;
    end;

    if (Result > max) then
    begin
      Writeln('"', val, '" must be lower then ', max);
      Continue;
    end;

    Break;
  until True;
end;

procedure SetWaveVolume(Volume: Double);
var
  Caps: TWAVEOUTCAPS;
  aVolume: Cardinal;
  VolumeCanal: Word;
begin
  VolumeCanal := Trunc(Volume * word(-1) / 100.0);
  aVolume := MakeLong(VolumeCanal, VolumeCanal);
  if WaveOutGetDevCaps(WAVE_MAPPER, @Caps, sizeof(Caps)) = MMSYSERR_NOERROR then
    if Caps.dwSupport and WAVECAPS_VOLUME = WAVECAPS_VOLUME then
      WaveOutSetVolume(WAVE_MAPPER, aVolume);
end;

procedure Play(music: string; volume: Double = 100.0; delayMs: Cardinal = 0);
begin
  SetWaveVolume(volume);
  PlaySound(Pchar(music), SND_SYNC, 0);
  if delayMs > 0 then
    Sleep(delayMs);
end;

var
  vol: Double = 100.0;
  i: Integer;
  rep: Integer;
  delay: DWORD;
  decay: Double;

begin
  rep := QueryIntNumber('Enter number of repetitions (1 to 20) : ', 1, 20);
  delay := QueryIntNumber('Enter delay between repetitions in milliseconds (0 to 1000) : ',
    0, 1000);

  decay := QueryFloatNumber('Enter decay between repetitions (0.01 to 0.99) : ',
    0.01, 0.99);

  for i := 1 to rep do
  begin
    Play('echo.wav', vol, delay);
    vol := vol * (1 - decay);
  end;
end.
