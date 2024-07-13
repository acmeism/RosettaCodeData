procedure MakeList(separator: string);
  var counter := 1;
  procedure MakeItem;
  begin
    Write(counter, separator);
    case counter of
      1: Writeln('first');
      2: Writeln('second');
      3: Writeln('third');
    end;
    counter += 1;
  end;
begin
	MakeItem;
	MakeItem;
	MakeItem;
end;

begin
  MakeList('. ');
end.
