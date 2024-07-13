type Person = class
  Name: string;
  Age: integer;
public
  constructor (Name: string; Age: integer);
  begin
    Self.Name := Name;
    Self.Age := Age;
  end;
  procedure Output := Print($'{Name} {Age}');
end;

begin
  var p := new Person('John',18);
  p.Output
end.
