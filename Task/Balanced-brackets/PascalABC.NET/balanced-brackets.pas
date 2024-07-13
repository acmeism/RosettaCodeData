function GenBracketExpr(n: integer): string;
begin
  var a := Arr('[',']')*n;
  Shuffle(a);
  Result := a.JoinToString
end;

function IsBalanced(s: string): boolean;
begin
  Result := True;
  var st := new Stack<char>;
  foreach var c in s do
    if c = '[' then
      st.Push(c)
    else if (st.Count > 0) and (st.Peek = '[') then
      st.Pop
    else begin
      Result := False;
      exit
    end;
end;

begin
  loop 10 do
  begin
    var s := GenBracketExpr(Random(2,5));
    Println(s, IsBalanced(s));
  end;
end.
