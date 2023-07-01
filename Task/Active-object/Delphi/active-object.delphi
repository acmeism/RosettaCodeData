program Active_object;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

type
  TIntegrator = class(TThread)
  private
    { Private declarations }
    interval, s: double;
    IsRunning: Boolean;
  protected
    procedure Execute; override;
  public
    k: Tfunc<Double, Double>;
    constructor Create(k: Tfunc<Double, Double>; inteval: double = 1e-4); overload;
    procedure Join;
  end;

{ TIntegrator }

constructor TIntegrator.Create(k: Tfunc<Double, Double>; inteval: double = 1e-4);
begin
  self.interval := Interval;
  self.K := k;
  self.S := 0.0;
  IsRunning := True;
  FreeOnTerminate := True;
  inherited Create(false);
end;

procedure TIntegrator.Execute;
var
  interval, t0, k0, t1, k1: double;
  start: Cardinal;
begin
  inherited;

  interval := self.interval;
  start := GetTickCount;
  t0 := 0;
  k0 := self.K(0);

  while IsRunning do
  begin
    t1 := (GetTickCount - start) / 1000;
    k1 := self.K(t1);
    self.S := self.S + ((k1 + k0) * (t1 - t0) / 2.0);
    t0 := t1;
    k0 := k1;
  end;
end;

procedure TIntegrator.Join;
begin
  IsRunning := false;
end;

var
  Integrator: TIntegrator;

begin
  Integrator := TIntegrator.create(
    function(t: double): double
    begin
      Result := sin(pi * t);
    end);

  sleep(2000);

  Writeln(Integrator.s);

  Integrator.k :=
    function(t: double): double
    begin
      Result := 0;
    end;

  sleep(500);
  Writeln(Integrator.s);
  Integrator.Join;
  Readln;
end.
