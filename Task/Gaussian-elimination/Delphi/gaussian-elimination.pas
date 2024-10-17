program GuassianElimination;

// Modified from:
// R. Sureshkumar (10 January 1997)
// Gregory J. McRae (22 October 1997)
// http://web.mit.edu/10.001/Web/Course_Notes/Gauss_Pivoting.c

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TMatrix = class
     private
      _r, _c : integer;
      data : array of TDoubleArray;
      function    getValue(rIndex, cIndex : integer): double;
      procedure   setValue(rIndex, cIndex : integer; value: double);
     public
      constructor Create (r, c : integer);
      destructor  Destroy; override;

      property r : integer read _r;
      property c : integer read _c;
      property value[rIndex, cIndex: integer]: double read getValue write setValue; default;
  end;


constructor TMatrix.Create (r, c : integer);
begin
  inherited Create;
  self.r := r; self.c := c;
  setLength (data, r, c);
end;

destructor TMatrix.Destroy;
begin
  data := nil;
  inherited;
end;

function TMatrix.getValue(rIndex, cIndex: Integer): double;
begin
  Result := data[rIndex-1, cIndex-1]; // 1-based array
end;

procedure TMatrix.setValue(rIndex, cIndex : integer; value: double);
begin
  data[rIndex-1, cIndex-1] := value; // 1-based array
end;

// Solve A x = b
procedure gauss (A, b, x : TMatrix);
var rowx : integer;
    i, j, k, n, m : integer;
    amax, xfac, temp, temp1 : double;
begin
  rowx := 0;  // Keep count of the row interchanges
  n := A.r;
  for k := 1 to n - 1 do
      begin
      amax := abs (A[k,k]);
      m := k;
      // Find the row with largest pivot
      for i := k + 1 to n do
          begin
          xfac := abs (A[i,k]);
          if xfac > amax then
             begin
             amax := xfac;
             m := i;
             end;
          end;

      if m <> k then
         begin  // Row interchanges
         rowx := rowx+1;
         temp1 := b[k,1];
         b[k,1] := b[m,1];
         b[m,1]  := temp1;
         for j := k to n do
             begin
             temp := a[k,j];
             a[k,j] := a[m,j];
             a[m,j] := temp;
             end;
      end;

      for i := k+1 to n do
          begin
          xfac := a[i, k]/a[k, k];
          for j := k+1 to n do
              a[i,j] := a[i,j]-xfac*a[k,j];
          b[i,1] := b[i,1] - xfac*b[k,1]
          end;
      end;

  // Back substitution
  for j := 1 to n do
      begin
      k := n-j + 1;
      x[k,1] := b[k,1];
      for i := k+1 to n do
          begin
          x[k,1] := x[k,1] - a[k,i]*x[i,1];
          end;
  x[k,1] := x[k,1]/a[k,k];
  end;
end;


var A, b, x : TMatrix;

begin
  try
    // Could have been done with simple arrays rather than a specific TMatrix class
    A := TMatrix.Create (4,4);
    // Note ideal but use TMatrix to define the vectors as well
    b := TMatrix.Create (4,1);
    x := TMatrix.Create (4,1);

    A[1,1] := 2; A[1,2] := 1; A[1,3] := 0; A[1,4] := 0;
    A[2,1] := 1; A[2,2] := 1; A[2,3] := 1; A[2,4] := 0;
    A[3,1] := 0; A[3,2] := 1; A[3,3] := 2; A[3,4] := 1;
    A[4,1] := 0; A[3,2] := 0; A[4,3] := 1; A[4,4] := 2;

    b[1,1] := 2; b[2,1] := 1; b[3,1] := 4; b[4,1] := 8;

    gauss (A, b, x);

    writeln (x[1,1]:5:2);
    writeln (x[2,1]:5:2);
    writeln (x[3,1]:5:2);
    writeln (x[4,1]:5:2);

    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
