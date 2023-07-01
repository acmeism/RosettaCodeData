program ListDemo;
uses
  classes;
var
  MyList: TList;
  a, b, c: integer;
  i: integer;
begin
  a := 1;
  b := 2;
  c := 3;
  MyList := TList.Create;
  MyList.Add(@a);
  MyList.Add(@c);
  MyList.Insert(1, @b);
  for i := MyList.IndexOf(MyList.First) to MyList.IndexOf(MyList.Last) do
    writeln (integer(MyList.Items[i]^));
  MyList.Destroy;
end.
