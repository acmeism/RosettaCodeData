program Sine_wave;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Winapi.Windows,
  Winapi.MMSystem;

type
  TWaveformSample = integer; // signed 32-bit; -2147483648..2147483647

  TWaveformSamples = packed array of TWaveformSample; // one channel

var
  Samples: TWaveformSamples;
  fmt: TWaveFormatEx;

procedure InitAudioSys;
begin
  with fmt do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := 1;
    nSamplesPerSec := 44100;
    wBitsPerSample := 32;
    nAvgBytesPerSec := nChannels * nSamplesPerSec * wBitsPerSample div 8;
    nBlockAlign := nChannels * wBitsPerSample div 8;
    cbSize := 0;
  end;
end;
                                          // Hz                     // msec

procedure CreatePureSineTone(const AFreq: integer; const ADuration: integer;
  const AVolume: double { in [0, 1] });
var
  i: Integer;
  omega, dt, t: double;
  vol: double;
begin
  omega := 2 * Pi * AFreq;
  dt := 1 / fmt.nSamplesPerSec;
  t := 0;
  vol := MaxInt * AVolume;
  SetLength(Samples, Round((ADuration / 1000) * fmt.nSamplesPerSec));
  for i := 0 to high(Samples) do
  begin
    Samples[i] := round(vol * sin(omega * t));
    t := t + dt;
  end;
end;

procedure PlaySound;
var
  wo: integer;
  hdr: TWaveHdr;
begin

  if Length(samples) = 0 then
  begin
    Writeln('Error: No audio has been created yet.');
    Exit;
  end;

  if waveOutOpen(@wo, WAVE_MAPPER, @fmt, 0, 0, CALLBACK_NULL) = MMSYSERR_NOERROR then
  try

    ZeroMemory(@hdr, sizeof(hdr));
    with hdr do
    begin
      lpData := @samples[0];
      dwBufferLength := fmt.nChannels * Length(Samples) * sizeof(TWaveformSample);
      dwFlags := 0;
    end;

    waveOutPrepareHeader(wo, @hdr, sizeof(hdr));
    waveOutWrite(wo, @hdr, sizeof(hdr));
    sleep(500);

    while waveOutUnprepareHeader(wo, @hdr, sizeof(hdr)) = WAVERR_STILLPLAYING do
      sleep(100);

  finally
    waveOutClose(wo);
  end;

end;

begin
  try
    InitAudioSys;
    CreatePureSineTone(440, 5000, 0.7);
    PlaySound;
  except
    on E: Exception do
    begin
      Writeln(E.Classname, ': ', E.Message);
      Readln;
    end;
  end;
end.
