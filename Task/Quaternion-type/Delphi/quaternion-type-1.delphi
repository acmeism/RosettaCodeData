unit Quaternions;

interface

type

  TQuaternion = record
    A, B, C, D: double;

    function  Init          (aA, aB, aC, aD : double): TQuaternion;
    function  Norm          : double;
    function  Conjugate     : TQuaternion;
    function  ToString      : string;

    class operator Negative (Left : TQuaternion): TQuaternion;
    class operator Positive (Left : TQuaternion): TQuaternion;
    class operator Add      (Left, Right : TQuaternion): TQuaternion;
    class operator Add      (Left : TQuaternion; Right : double): TQuaternion; overload;
    class operator Add      (Left : double; Right : TQuaternion): TQuaternion; overload;
    class operator Subtract (Left, Right : TQuaternion): TQuaternion;
    class operator Multiply (Left, Right : TQuaternion): TQuaternion;
    class operator Multiply (Left : TQuaternion; Right : double): TQuaternion; overload;
    class operator Multiply (Left : double; Right : TQuaternion): TQuaternion; overload;
  end;

implementation

uses
  SysUtils;

{ TQuaternion }

function TQuaternion.Init(aA, aB, aC, aD: double): TQuaternion;
begin
  A := aA;
  B := aB;
  C := aC;
  D := aD;

  result := Self;
end;

function TQuaternion.Norm: double;
begin
  result := sqrt(sqr(A) + sqr(B) + sqr(C) + sqr(D));
end;

function TQuaternion.Conjugate: TQuaternion;
begin
  result.B := -B;
  result.C := -C;
  result.D := -D;
end;

class operator TQuaternion.Negative(Left: TQuaternion): TQuaternion;
begin
  result.A := -Left.A;
  result.B := -Left.B;
  result.C := -Left.C;
  result.D := -Left.D;
end;

class operator TQuaternion.Positive(Left: TQuaternion): TQuaternion;
begin
  result := Left;
end;

class operator TQuaternion.Add(Left, Right: TQuaternion): TQuaternion;
begin
  result.A := Left.A + Right.A;
  result.B := Left.B + Right.B;
  result.C := Left.C + Right.C;
  result.D := Left.D + Right.D;
end;

class operator TQuaternion.Add(Left: TQuaternion; Right: double): TQuaternion;
begin
  result.A := Left.A + Right;
  result.B := Left.B;
  result.C := Left.C;
  result.D := Left.D;
end;

class operator TQuaternion.Add(Left: double; Right: TQuaternion): TQuaternion;
begin
  result.A := Left + Right.A;
  result.B := Right.B;
  result.C := Right.C;
  result.D := Right.D;
end;

class operator TQuaternion.Subtract(Left, Right: TQuaternion): TQuaternion;
begin
  result.A := Left.A - Right.A;
  result.B := Left.B - Right.B;
  result.C := Left.C - Right.C;
  result.D := Left.D - Right.D;
end;

class operator TQuaternion.Multiply(Left, Right: TQuaternion): TQuaternion;
begin
  result.A := Left.A * Right.A - Left.B * Right.B - Left.C * Right.C - Left.D * Right.D;
  result.B := Left.A * Right.B + Left.B * Right.A + Left.C * Right.D - Left.D * Right.C;
  result.C := Left.A * Right.C - Left.B * Right.D + Left.C * Right.A + Left.D * Right.B;
  result.D := Left.A * Right.D + Left.B * Right.C - Left.C * Right.B + Left.D * Right.A;
end;

class operator TQuaternion.Multiply(Left: double; Right: TQuaternion): TQuaternion;
begin
  result.A := Left * Right.A;
  result.B := Left * Right.B;
  result.C := Left * Right.C;
  result.D := Left * Right.D;
end;

class operator TQuaternion.Multiply(Left: TQuaternion; Right: double): TQuaternion;
begin
  result.A := Left.A * Right;
  result.B := Left.B * Right;
  result.C := Left.C * Right;
  result.D := Left.D * Right;
end;

function TQuaternion.ToString: string;
begin
  result := Format('%f + %fi + %fj + %fk', [A, B, C, D]);
end;

end.
