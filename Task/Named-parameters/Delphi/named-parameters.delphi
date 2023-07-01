program Named_parameters;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TParams = record
    fx, fy, fz: Integer;
    function x(value: Integer): TParams;
    function y(value: Integer): TParams;
    function z(value: Integer): TParams;
    class function _: TParams; static;
  end;

function Sum(Param: TParams): Integer;
begin
  Result := Param.fx + Param.fy + Param.fz;
end;

{ TParams }

function TParams.x(value: Integer): TParams;
begin
  Result := Self;
  Result.fx := value;
end;

function TParams.y(value: Integer): TParams;
begin
  Result := Self;
  Result.fy := value;
end;

function TParams.z(value: Integer): TParams;
begin
  Result := Self;
  Result.fz := value;
end;

class function TParams._: TParams;
begin
  Result.fx := 0;  // default x
  Result.fy := 0;  // default y
  Result.fz := 0;  // default z
end;

begin
  writeln(sum(TParams._.x(2).y(3).z(4))); // 9

  writeln(sum(TParams._.z(4).x(3).y(5))); // 12

  {$IFNDEF UNIX} readln; {$ENDIF}
end.
