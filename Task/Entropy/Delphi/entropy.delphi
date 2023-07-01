program Entropytest;

uses
  StrUtils,
  Math;

type
  FArray = array of CARDINAL;

var
  strng: string = '1223334444';

// list unique characters in a string
function uniquechars(str: string): string;
var
  n: CARDINAL;
begin
  Result := '';
  for n := 1 to length(str) do
    if (PosEx(str[n], str, n) > 0) and (PosEx(str[n], Result, 1) = 0) then
      Result := Result + str[n];
end;

// obtain a list of character-frequencies for a string
//  given a string containing its unique characters
function frequencies(str, ustr: string): FArray;
var
  u, s, p, o: CARDINAL;
begin
  SetLength(Result, Length(ustr) + 1);
  p := 0;
  for u := 1 to length(ustr) do
    for s := 1 to length(str) do
    begin
      o := p;
      p := PosEx(ustr[u], str, s);
      if (p > o) then
        INC(Result[u]);
    end;
end;

// Obtain the Shannon entropy of a string
function entropy(s: string): EXTENDED;
var
  pf: FArray;
  us: string;
  i, l: CARDINAL;
begin
  us := uniquechars(s);
  pf := frequencies(s, us);
  l := length(s);
  Result := 0.0;
  for i := 1 to length(us) do
    Result := Result - pf[i] / l * log2(pf[i] / l);
end;

begin
  Writeln('Entropy of "', strng, '" is ', entropy(strng): 2: 5, ' bits.');
  readln;
end.
