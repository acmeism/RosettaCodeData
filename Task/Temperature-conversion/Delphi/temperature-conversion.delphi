program Temperature;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TTemp = class
  private
    fCelsius, fFahrenheit, fRankine: double;
  public
    constructor Create(aKelvin: double);
    property AsCelsius: double read fCelsius;
    property AsFahrenheit: double read fFahrenheit;
    property AsRankine: double read fRankine;
  end;

  { TTemp }

constructor TTemp.Create(aKelvin: double);
begin
  fCelsius := aKelvin - 273.15;
  fRankine := aKelvin * 9 / 5;
  fFahrenheit := fRankine - 459.67;
end;

var
  kelvin: double;
  temp: TTemp;

begin
  write('Kelvin: ');
  readln(kelvin);
  temp := TTemp.Create(kelvin);
  writeln(Format('Celsius: %.2f', [temp.AsCelsius]));
  writeln(Format('Fahrenheit: %.2f', [temp.AsFahrenheit]));
  writeln(Format('Rankine: %.2f', [temp.AsRankine]));
  temp.Free;
  readln;
end.
