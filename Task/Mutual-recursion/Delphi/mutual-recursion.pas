unit Hofstadter;

interface

type
  THofstadterFemaleMaleSequences = class
  public
    class function F(n: Integer): Integer;
    class function M(n: Integer): Integer;
  end;

implementation

class function THofstadterFemaleMaleSequences.F(n: Integer): Integer;
begin
  Result:= 1;
  if (n > 0) then
    Result:= n - M(F(n-1));
end;

class function THofstadterFemaleMaleSequences.M(n: Integer): Integer;
begin
  Result:= 0;
  if (n > 0) then
    Result:= n - F(M(n - 1));
end;

end.
